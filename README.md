# ByteOrderedFloat

A utility library for encoding and decoding floats into 64-bit binaries that retain float sorting order.

The ordering of floats is preserved when using `ByteOrderedFloat` to encode floats. For example, comparing floats `a` and `b` if float `a` is greater than float `b` then the encoding for `a` will be greater than the encoding for `b`.

```elixir
iex> 1.0 > -1.0
true

iex> ByteOrderedFloat.encode(1.0) > ByteOrderedFloat.encode(-1.0)
true
```

## Basic Usage

Use `ByteOrderedFloat.encode/1` to encode floats and `ByteOrderedFloat.decode/1` to decode encoded floats.

Encoding non-floats, or decoding invalid binaries or non-binaries will return `:error`

```elixir
iex> ByteOrderedFloat.encode(0.1)
{:ok, <<191, 185, 153, 153, 153, 153, 153, 154>>}

iex> ByteOrderedFloat.decode(<<191, 185, 153, 153, 153, 153, 153, 154>>)
{:ok, 0.1}

iex> ByteOrderedFloat.encode(:not_a_float)
:error

iex> ByteOrderedFloat.decode("not a valid float-encoding binary")
:error
```

## Order Preservation

### Zero

Encoded `0.0` is the "middle" value; the leftmost bit is a `1` and all other bits are `0`.

```elixir

iex> ByteOrderedFloat.encode(0.0)
{:ok, <<128, 0, 0, 0, 0, 0, 0, 0>>}
```

### Negatives

Encoded negative floats are less than zero.

```elixir
# the most positive float
iex> ByteOrderedFloat.encode(-1.7976931348623157E+308)
{:ok, <<0, 16, 0, 0, 0, 0, 0, 0>>}

# the nearest-to-zero negative float
iex> ByteOrderedFloat.encode(-1.7976931348623157E-308)
{:ok, <<127, 243, 18, 189, 19, 119, 162, 98>>}

# a commonly used negative value: -1.0
iex> ByteOrderedFloat.encode(-1.0)
{:ok, <<64, 15, 255, 255, 255, 255, 255, 255>>}
```

### Positives

Encoded positives are greater than zero.

```elixir
# the most negative float
iex> ByteOrderedFloat.encode(1.7976931348623157E+308)
{:ok, <<255, 239, 255, 255, 255, 255, 255, 255>>}

# the nearest-to-zero positive float
iex> ByteOrderedFloat.encode(1.7976931348623157E-308)
{:ok, <<128, 12, 237, 66, 236, 136, 93, 157>>}

# a commonly used positive value: 1.0
iex> ByteOrderedFloat.encode(1.0)
{:ok, <<191, 240, 0, 0, 0, 0, 0, 0>>}
```

## Installation

[ByteOrderedFloat is available in Hex](https://hex.pm/packages/byte_ordered_float)

The package can be installed from hex by adding `byte_ordered_float` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:byte_ordered_float, "~> 0.1.1"}
  ]
end
```
