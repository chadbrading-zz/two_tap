defmodule TwoTap.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  post "/confirm_purchase" do
    TwoTap.Callbacks.confirm_purchase(conn)
    |> send_resp(200, :ok)
  end
end
