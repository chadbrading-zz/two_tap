defmodule TwoTap.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/purchase_status" do
    TwoTap.Callbacks.update_purchase_status(conn)
    |> send_resp(200, "confirm purchase?")
  end
end
