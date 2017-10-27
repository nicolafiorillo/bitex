defmodule Bitex.Kernel do
  @moduledoc """
  IDs are little-endian represented.
  """

  @doc """
  Used to generate id for blocks and transactions (txid):
    block_id = hash256(block.header)
    transaction_id = hash256(transaction)
  """
  def hash256(d) when is_binary(d) or is_bitstring(d), do: d |> sha256 |> sha256

  @doc """
  Used to generate id for addresses.
  """
  def hash160(d) when is_binary(d) or is_bitstring(d), do: d |> sha256 |> ripemd160

  def serialize(a) when is_list(a) do
    a |> Enum.reduce([],
      fn
        %Bitex.FixedLengthString{length: size, string: str}, acc ->
          pad_size = size - String.length(str)
          elem = (for <<b::8 <- str>>, do: b) ++ (for _ <- 1..pad_size, do: 0)
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

  def value_from_varint([]), do: raise "invalid varint"
  def value_from_varint([0xFF | payload]) when is_list(payload) and length(payload) >= 8, do: payload |> Enum.slice(0, 8)
  def value_from_varint([0xFF | payload]) when is_list(payload), do: raise "invalid varint 64"
  def value_from_varint([0xFE | payload]) when is_list(payload) and length(payload) >= 4, do: payload |> Enum.slice(0, 4)
  def value_from_varint([0xFE | payload]) when is_list(payload), do: raise "invalid varint 32"
  def value_from_varint([0xFD | payload]) when is_list(payload) and length(payload) >= 2, do: payload |> Enum.slice(0, 2)
  def value_from_varint([0xFD | payload]) when is_list(payload), do: raise "invalid varint 16"
  def value_from_varint([first | _]), do: [first]

  defp sha256(d) when is_binary(d) or is_bitstring(d), do: :crypto.hash(:sha256, d)
  defp ripemd160(d) when is_binary(d) or is_bitstring(d), do: :crypto.hash(:ripemd160, d)
end
