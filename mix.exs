defmodule ByteOrderedFloat.MixProject do
  use Mix.Project

  def project do
    [
      app: :byte_ordered_float,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp description() do
    "A few sentences (a paragraph) describing the project."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "byte_ordered_float",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*
                license* CHANGELOG* changelog* src),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/elixir-ecto/postgrex"}
    ]
  end
end
