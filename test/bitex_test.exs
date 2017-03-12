defmodule BitexTest do
  use ExUnit.Case
  doctest Bitex

  test "serialize 1" do
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

  test "serialize 2" do
      n32 = 0x68f7a38b
      str = {10, "FooBar"}
      n16 = 0xee12

      a = [n32, str, n16]
      assert Bitex.Kernel.serialize(a) == [0x8B, 0xA3, 0xF7, 0x68,
                                            0x46, 0x6F, 0x6F, 0x42, 0x61, 0x72, 0x00, 0x00, 0x00, 0x00,
                                            0x12, 0xEE]
  end
end
