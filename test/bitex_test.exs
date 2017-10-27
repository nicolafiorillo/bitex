defmodule BitexTest do
  use ExUnit.Case
  doctest Bitex

  test "serialize integers" do
    n8 = 0x01
    n16 = 0x4523
    n32 = 0xcdab8967
    n64 = 0xdebc9a78563412ef

    a = [n8, n16, n32, n64]
    assert Bitex.Kernel.serialize(a) == [0x01,
                                          0x23, 0x45,
                                          0x67, 0x89, 0xAB, 0xCD,
                                          0xEF, 0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE]
  end

  test "serialize fixed-length data: null-padded string" do
    n32 = 0x68f7a38b
    str = %Bitex.FixedLengthString{length: 10, string: "FooBar"}
    n16 = 0xee12

    a = [n32, str, n16]
    assert Bitex.Kernel.serialize(a) == [0x8B, 0xA3, 0xF7, 0x68,
                                          0x46, 0x6F, 0x6F, 0x42, 0x61, 0x72, 0x00, 0x00, 0x00, 0x00,
                                          0x12, 0xEE]
  end

  test "serialize fixed-length data: hashes" do
    message = "Hello Bitcoin!"
    prefix = 0xd17f
    suffix = 0x8c

    a = [prefix, Bitex.Kernel.hash256(message), suffix]
    assert Bitex.Kernel.serialize(a) == [0x7F, 0xD1,
                                          0x90, 0x98, 0x6E, 0xA4, 0xE2, 0x8B, 0x84, 0x7C,
                                          0xC7, 0xF9, 0xBE, 0xBA, 0x87, 0xEA, 0x81, 0xB2,
                                          0x21, 0xCA, 0x6E, 0xAF, 0x98, 0x28, 0xA8, 0xB0,
                                          0x4C, 0x29, 0x0C, 0x21, 0xD8, 0x91, 0xBC, 0xDA,
                                          0x8C]
  end

  test "value_from_varint int64" do
    a = [0xFF, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]
    assert Bitex.Kernel.value_from_varint(a) == [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]
  end

  test "value_from_varint int64 and more" do
    a = [0xFF, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09]
    assert Bitex.Kernel.value_from_varint(a) == [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]
  end

  test "value_from_varint int64 but less" do
    a = [0xFF, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
    assert_raise RuntimeError, "invalid varint 64", fn -> Bitex.Kernel.value_from_varint(a) end
  end

  test "value_from_varint int32" do
    a = [0xFE, 0x01, 0x02, 0x03, 0x04]
    assert Bitex.Kernel.value_from_varint(a) == [0x01, 0x02, 0x03, 0x04]
  end

  test "value_from_varint int32 and more" do
    a = [0xFE, 0x01, 0x02, 0x03, 0x04, 0x5]
    assert Bitex.Kernel.value_from_varint(a) == [0x01, 0x02, 0x03, 0x04]
  end

  test "value_from_varint int32 but less" do
    a = [0xFE, 0x01, 0x02, 0x03]
    assert_raise RuntimeError, "invalid varint 32", fn -> Bitex.Kernel.value_from_varint(a) end
  end

  test "value_from_varint int16" do
    a = [0xFD, 0x01, 0x02]
    assert Bitex.Kernel.value_from_varint(a) == [0x01, 0x02]
  end

  test "value_from_varint int16 and more" do
    a = [0xFD, 0x01, 0x02, 0x03]
    assert Bitex.Kernel.value_from_varint(a) == [0x01, 0x02]
  end

  test "value_from_varint int16 but less" do
    a = [0xFD, 0x01]
    assert_raise RuntimeError, "invalid varint 16", fn -> Bitex.Kernel.value_from_varint(a) end
  end

  test "value_from_varint int8" do
    a = [0x01]
    assert Bitex.Kernel.value_from_varint(a) == [0x01]
  end

  test "value_from_varint int8 and more" do
    a = [0x01, 0x02]
    assert Bitex.Kernel.value_from_varint(a) == [0x01]
  end

  test "value_from_varint empty" do
    a = []
    assert_raise RuntimeError, "invalid varint", fn -> Bitex.Kernel.value_from_varint(a) end
  end
end
