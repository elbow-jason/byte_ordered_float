defmodule ByteOrderedFloat do
  @moduledoc """
  ByteOrderedFloat is used to encode (and decode) float values into bigendian-like, order-preserving
  binaries.

  ## BIG THANKS

  Big thanks to Aravind Ravi-Sulekha for a super helpful article.

  The description:

  The most significant bit is the sign bit. As all positive numbers are
  higher than all negative numbers, we should flip the sign bit so it’s 1
  for positive numbers and 0 for negative numbers.

  For negative numbers, we additionally perform a bitwise NOT of the E and M
  bits so that larger negative numbers get sorted before smaller ones.

  Source: https://medium.com/@aravindet/order-preserving-encoding-for-floats-cde09c978629
  """
  import Bitwise

  @doc """
  Encodes floats into a 8-byte binary that is float-order preserving.
  """
  @spec encode(any) :: :error | {:ok, <<_::64>>}
  def encode(f) when is_float(f) do
    {:ok, encode_float_order_preserved(<<f::big-float-size(64)>>)}
  end

  def encode(_) do
    :error
  end

  # zero - all 64 bits are zeros therefore the value is zero.
  defp encode_float_order_preserved(<<0::64>> = zero) do
    zero
  end

  # negative - when first bit is 1
  defp encode_float_order_preserved(
         <<1::1, exp::big-unsigned-integer-size(11), frac::big-unsigned-integer-size(52)>>
       ) do
    e_exp = bnot(exp)
    e_frac = bnot(frac)
    <<0::1, e_exp::big-signed-integer-size(11), e_frac::big-signed-integer-size(52)>>
  end

  # positive - when first bit is 0
  defp encode_float_order_preserved(<<0::1, rest::63>>) do
    <<1::1, rest::63>>
  end

  @doc """
  Decodes an ByteOrderedFloat encoded binary into a float.
  """
  @spec decode(any) :: :error | {:ok, float}
  def decode(encoded_float)

  def decode(<<1::1, rest::63>>) do
    <<f::big-float-size(64)>> = <<0::1, rest::63>>
    {:ok, f}
  end

  def decode(<<0::64>>) do
    {:ok, 0.0}
  end

  def decode(<<0::1, e_exp::big-signed-integer-size(11), e_frac::big-signed-integer-size(52)>>) do
    exp = bnot(e_exp)
    frac = bnot(e_frac)

    <<f::big-float-size(64)>> =
      <<1::1, exp::big-unsigned-integer-size(11), frac::big-unsigned-integer-size(52)>>

    {:ok, f}
  rescue
    MatchError ->
      :error
  end

  def decode(_) do
    :error
  end
end
