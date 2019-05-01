defmodule Deribit.MixProject do
  use Mix.Project

  def project do
    [
      app: :deribit,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Deribit",
      source_url: "https://github.com/gabrielpra1/deribit-elixir",
      description: " Deribit v2 API client for Elixir",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs README*),
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/gabrielpra1/deribit-elixir",
        "Docs" => "https://hexdocs.pm/crudry/"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:httpoison, "~> 1.4"},
      {:jason, "~> 1.1"}
    ]
  end
end
