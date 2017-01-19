use Mix.Config

config :logger, level: :info

config :two_tap, two_tap_api: TwoTap.HTTPClient
config :two_tap, amqp: AMQP

import_config "prod.secret.exs"
