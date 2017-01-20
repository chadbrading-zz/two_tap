use Mix.Config

config :logger, :console,
  format: "[$level] $message\n"

config :two_tap, confirm_purchase_callback: "https://twotapclient.localtunnel.me/confirm_purchase"
config :two_tap, update_purchase_callback: "https://twotapclient.localtunnel.me/update_purchase"

config :two_tap, two_tap_api: TwoTap.HTTPClient
config :two_tap, amqp: AMQP

config :two_tap, amqp_url: "amqp://guest:guest@localhost"
config :two_tap, amqp_exchange: "dev_exchange"
config :two_tap, amqp_queue: "dev_queue"
config :two_tap, amqp_queue_error: "dev_queue_error"

import_config "prod.secret.exs"
