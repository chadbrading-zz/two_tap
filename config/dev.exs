use Mix.Config

config :two_tap, two_tap_api: TwoTap.HTTPClient
config :two_tap, purchase_callback: "https://twotapclient.localtunnel.me"

import_config "prod.secret.exs"
