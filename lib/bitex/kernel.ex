defmodule Bitex.Kernel do
  def hash256(d) when is_binary(d) or is_bitstring(d), do: d |> sha256 |> sha256
  def hash160(d) when is_binary(d) or is_bitstring(d), do: d |> sha256 |> ripemd160

  def serialize(a) when is_list(a) do
    a |> Enum.reduce([],
      fn
        {size, str}, acc ->
          size = size - String.length(str)
          elem = (for <<b::8 <- str>>, do: b) ++ (for _ <- 1..size, do: 0)
          acc ++ elem
        bin, acc when is_binary(bin) ->
          elem = for <<b::8 <- bin>>, do: b
          acc ++ elem
        elem, acc ->
          size = elem |> :binary.encode_unsigned() |> byte_size()
          str = <<elem :: little-size(size)-unit(8)>>
          acc ++ (for <<b::8 <- str>>, do: b)
      end)
  end

  defp sha256(d) when is_binary(d) or is_bitstring(d), do: :crypto.hash(:sha256, d)
  defp ripemd160(d) when is_binary(d) or is_bitstring(d), do: :crypto.hash(:ripemd160, d)
end
