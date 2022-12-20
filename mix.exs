defmodule ByteOrderedFloat.MixProject do
  use Mix.Project

  @github_url "https://github.com/elbow-jason/byte_ordered_float"
  @version "0.1.2"
  @description "ByteOrderFloat handles encoding and decoding for 64-bit floating point numbers with sorting order preserved."

  def project do
    [
      app: :byte_ordered_float,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      deps: deps(),
      name: "ByteOrderedFloat",
      description: @description,
      package: package(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.14.4", only: :test}
    ]
  end

  defp docs do
    [
      # main: "readme",
      source_ref: "v#{@version}",
      source_url: @github_url
      # extras: [
      #   "./readme.md"
      # ]
    ]
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "byte_ordered_float",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs readme* LICENSE*),
      maintainers: ["Jason Goldberger"],
      licenses: ["MIT"],
      links: %{"GitHub" => @github_url}
    ]
  end
end
