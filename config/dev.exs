use Mix.Config

config :two_tap, two_tap_api: TwoTap.HTTPClient
config :two_tap, confirm_purchase_callback: "https://twotapclient.localtunnel.me/confirm_purchase"
config :two_tap, update_purchase_callback: "https://twotapclient.localtunnel.me/update_purchase"

import_config "prod.secret.exs"
