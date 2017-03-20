defmodule Bitex.Key do

  @openssl_exec     System.find_executable("openssl")
  @path             Application.app_dir(:bitex, "priv/keys")
  @private_key_file "ec-priv.pem"
  @public_key_file  "ec-pub.pem"

  def generate_keys() do
    args = ["ecparam", "-name", "secp256k1", "-genkey", "-out", full_path(@private_key_file)]
    System.cmd(@openssl_exec, args)

    args = ["ec", "-in", full_path(@private_key_file), "-pubout", "-out", full_path(@public_key_file)]
    System.cmd(@openssl_exec, args)
  end

  def delete_keys() do
    File.rm(full_path(@public_key_file))
    File.rm(full_path(@private_key_file))
  end

  defp full_path(file_name), do: "#{@path}/#{file_name}"
end
