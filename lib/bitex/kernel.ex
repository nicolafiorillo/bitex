defmodule Bitex.Kernel do
  @moduledoc """
  IDs are little-endian represented.
  """

  @doc """
  Used to generate id for blocks and transactions (txid).
  """
  def hash256(d) when is_binary(d) or is_bitstring(d), do: d |> sha256 |> sha256

  @doc """
  Used to generate id for addresses.
  """
  def hash160(d) when is_binary(d) or is_bitstring(d), do: d |> sha256 |> ripemd160

  def encode(a) when is_list(a) do
    a |> Enum.reduce([],
      fn
        %Bitex.FixedLengthString{length: size, string: str}, acc ->
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

  def value_from_varint([0xFF | [b1 | [b2 | [b3 | [b4 | rest]]]]]), do: Enum.slice(rest, 0, merge_int(b1, b2, b3, b4))
  def value_from_varint([0xFE | [b1 | [b2 | [b3 | rest]]]]), do: Enum.slice(rest, 0, merge_int(b1, b2, b3))
  def value_from_varint([0xFD | [b1 | [b2 | rest]]]), do: Enum.slice(rest, 0, merge_int(b1, b2))
  def value_from_varint([first | _]), do: [first]

  defp sha256(d) when is_binary(d) or is_bitstring(d), do: :crypto.hash(:sha256, d)
  defp ripemd160(d) when is_binary(d) or is_bitstring(d), do: :crypto.hash(:ripemd160, d)

  defp merge_int(b1, b2), do: b1 + b2 * 10
  defp merge_int(b1, b2, b3), do: b1 + b2 * 10 + b3 * 100
  defp merge_int(b1, b2, b3, b4), do: b1 + b2 * 10 + b3 * 100 + b4 * 1000
end
