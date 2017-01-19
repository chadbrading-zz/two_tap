use Mix.Config

config :two_tap, two_tap_api: TwoTap.Stub
config :two_tap, confirm_purchase_callback: "localhost:4004/confirm_purchase"
config :two_tap, update_purchase_callback: "localhost:4004/update_purchase"
config :two_tap, public_token: "test_token"
config :two_tap, private_token: "test_token"
config :two_tap, test_mode: "dummy_data"
