defmodule Bitex.Key do

  @openssl_exec             System.find_executable("openssl")
  @path                     Application.app_dir(:bitex, "priv/keys")
  @private_key_file_suffix  ".ec-priv.pem"
  @public_key_file_suffix   ".ec-pub.pem"

  def generate_keys() do
    id = UUID.uuid4(:hex)
    private_file = private_file_full_name(id)
    public_file = public_file_full_name(id)

    args = ["ecparam", "-name", "secp256k1", "-genkey", "-out", private_file]
    System.cmd(@openssl_exec, args)

    args = ["ec", "-in", private_file, "-pubout", "-out", public_file]
    System.cmd(@openssl_exec, args)

    {:ok, id}
  end

  def get_current_id() do
    {:ok, files} = File.ls(@path)
    private_keys = Enum.filter(files, fn f -> String.ends_with?(f, @private_key_file_suffix) end)
    case length(private_keys) do
      0 -> {:error, :no_keys}
      1 -> {:ok, String.trim_trailing(List.first(private_keys), @private_key_file_suffix)}
      _ -> {:error, :more_keys}
    end
  end

  def delete_keys(id) do
    File.rm(private_file_full_name(id))
    File.rm(public_file_full_name(id))
  end

  defp full_path(file_name), do: "#{@path}/#{file_name}"
  defp private_file_full_name(file_name), do: full_path(file_name <> @private_key_file_suffix)
  defp public_file_full_name(file_name), do: full_path(file_name <> @public_key_file_suffix)
end
