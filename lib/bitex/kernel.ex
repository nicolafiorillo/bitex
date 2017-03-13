defmodule Bitex.Kernel do
  def hash256(d) when is_binary(d) or is_bitstring(d), do: d |> sha256 |> sha256
  def hash160(d) when is_binary(d) or is_bitstring(d), do: d |> sha256 |> ripemd160

  def encode(a) when is_list(a) do
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

  def decode([0xFF | int64]), do: Enum.slice(int64, 0, 8)
  def decode([0xFE | int32]), do: Enum.slice(int32, 0, 4)
  def decode([0xFD | int16]), do: Enum.slice(int16, 0, 2)
  def decode([int8]), do: [int8]

  defp sha256(d) when is_binary(d) or is_bitstring(d), do: :crypto.hash(:sha256, d)
  defp ripemd160(d) when is_binary(d) or is_bitstring(d), do: :crypto.hash(:ripemd160, d)
end
