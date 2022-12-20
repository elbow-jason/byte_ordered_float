defmodule ByteOrderedFloat.MixProject do
  use Mix.Project

  @github_url "https://github.com/elbow-jason/byte_ordered_float"

  def project do
    [
      app: :byte_ordered_float,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "ByteOrderedFloat",
      package: package(),
      description: description(),
      source_url: @github_url
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    []
  end

  defp description() do
    "ByteOrderFloat handles encoding and decoding for 64-bit floating point numbers with order preserved;" <>
      " sorting a list of floats and sorting a list of encoded floats results in the same ordering."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "byte_ordered_float",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => @github_url}
    ]
  end
end
