defmodule ByteOrderedFloatTest do
  use ExUnit.Case
  doctest ByteOrderedFloat

  defp random_float(scale) do
    signed =
      case :rand.normal() do
        x when x < 0.0 ->
          -1.0

        _ ->
          1.0
      end

    :rand.uniform() * scale * signed
  end

  defp random_floats(n, scale \\ 1.0) do
    Enum.map(1..n, fn _ -> random_float(scale) end)
  end

  describe "encode/1" do
    test "preserves order" do
      sorted = Enum.sort(random_floats(100_000))

      encoded =
        Enum.map(sorted, fn f ->
          assert {:ok, bof} = ByteOrderedFloat.encode(f)
          bof
        end)

      # the encoded list is already sorted.
      assert Enum.sort(encoded) == encoded
    end
  end

  describe "decode/2" do
    test "preserves values" do
      floats = random_floats(100_000)
      assert is_float(hd(floats))

      encoded =
        Enum.map(floats, fn f ->
          assert {:ok, bof} = ByteOrderedFloat.encode(f)
          bof
        end)

      decoded =
        Enum.map(encoded, fn e ->
          assert {:ok, f} = ByteOrderedFloat.decode(e)
          f
        end)

      assert is_float(hd(decoded))
      assert decoded == floats
    end

    test "errors when binary is invalid" do
      assert :error = ByteOrderedFloat.decode("")
      assert :error = ByteOrderedFloat.decode("hi")
      assert :error = ByteOrderedFloat.decode(<<10::size(64)>>)
      assert :error = ByteOrderedFloat.decode("this binary is too long to be valid")
    end
  end
end
