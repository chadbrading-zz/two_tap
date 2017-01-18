defmodule TwoTap.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  post "start_purchase" do
    TwoTap.Callbacks.start_purchase(conn)
    |> send_resp(200, :ok)
  end

  post "/confirm_purchase" do
    TwoTap.Callbacks.confirm_purchase(conn)
    |> send_resp(200, :ok)
  end

  post "/purchase_complete" do
    TwoTap.Callbacks.purchase_complete(conn)
    |> send_resp(200, :ok)
  end
end
