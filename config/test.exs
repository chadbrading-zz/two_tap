use Mix.Config

config :logger, level: :warn

config :two_tap, confirm_purchase_callback: "localhost:4004/confirm_purchase"
config :two_tap, update_purchase_callback: "localhost:4004/update_purchase"

config :two_tap, public_token: "test_token"
config :two_tap, private_token: "test_token"

config :two_tap, two_tap_api: TwoTap.Stub
config :two_tap, test_mode: "dummy_data"
config :two_tap, amqp: FakeAMQP

config :two_tap, amqp_url: "amqp://guest:guest@localhost"
config :two_tap, amqp_exchange: "test_exchange"
config :two_tap, amqp_queue: "test_queue"
config :two_tap, amqp_queue_error: "test_queue_error"
