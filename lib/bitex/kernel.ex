defmodule Bitex.Kernel do
  def hash256(d) when is_binary(d) or is_bitstring(d), do: d |> sha256 |> sha256
  def hash160(d) when is_binary(d) or is_bitstring(d), do: d |> sha256 |> ripemd160

  defp sha256(d) when is_binary(d) or is_bitstring(d), do: :crypto.hash(:sha256, d)
  defp ripemd160(d) when is_binary(d) or is_bitstring(d), do: :crypto.hash(:ripemd160, d)
end
