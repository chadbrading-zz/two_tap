use Mix.Config

config :two_tap, two_tap_api: TwoTap.Stub
config :two_tap, purchase_callback: "localhost:4004/purchase_status"
config :two_tap, public_token: "test_token"
config :two_tap, private_token: "test_token"
