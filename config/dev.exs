use Mix.Config

config :logger, :console,
  format: "[$level] $message\n"

config :two_tap, confirm_purchase_callback: "https://twotapclient.localtunnel.me/confirm_purchase"
config :two_tap, update_purchase_callback: "https://twotapclient.localtunnel.me/update_purchase"

config :two_tap, two_tap_api: TwoTap.HTTPClient
config :two_tap, amqp: AMQP

import_config "prod.secret.exs"
