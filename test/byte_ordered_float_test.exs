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

  test "preserves order when dealing with max and min float values" do
    min_f = -1.7976931348623157e+308
    max_f = 1.7976931348623157e+308
    assert min_f < 0.0
    assert max_f > 0.0

    assert {:ok, min_e} = ByteOrderedFloat.encode(min_f)
    assert {:ok, max_e} = ByteOrderedFloat.encode(max_f)
    assert {:ok, zero_e} = ByteOrderedFloat.encode(0.0)

    assert min_e < zero_e
    assert max_e > zero_e
  end

  test "preserves order when dealing with near-zero float values" do
    neg_f = -1.7976931348623157e-308
    pos_f = 1.7976931348623157e-308
    assert neg_f < 0.0
    assert pos_f > 0.0

    assert {:ok, neg_e} = ByteOrderedFloat.encode(neg_f)
    assert {:ok, pos_e} = ByteOrderedFloat.encode(pos_f)
    assert {:ok, zero_e} = ByteOrderedFloat.encode(0.0)

    assert neg_e < zero_e
    assert pos_e > zero_e
  end

  test "can encode and decode zero" do
    assert {:ok, zero} = ByteOrderedFloat.encode(0.0)
    assert {:ok, 0.0} == ByteOrderedFloat.decode(zero)
    assert zero == <<128, 0, 0, 0, 0, 0, 0, 0>>
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
