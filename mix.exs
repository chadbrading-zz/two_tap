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
    [applications: [:logger, :cowboy, :plug, :httpoison, :amqp, :amqp_client],
     mod: {TwoTap, []}]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:httpoison, "~> 0.10.0"},
      {:json, "~> 1.0"},
      {:amqp, "0.1.4"},
      {:amqp_client, git: "https://github.com/jbrisbin/amqp_client.git", override: true},
      {:rabbit_common, github: "jbrisbin/rabbit_common", override: true}
    ]
  end
end
