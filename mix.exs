defmodule TwoTap.Mixfile do
  use Mix.Project

  def project do
    [app: :two_tap,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :cowboy, :plug, :httpoison],
     mod: {TwoTap, []}]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:httpoison, "~> 0.10.0"},
      {:json, "~> 1.0"}
    ]
  end
end
