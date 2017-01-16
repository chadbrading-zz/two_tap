defmodule TwoTap.Callbacks do
  def confirm_purchase(conn) do
    {:ok, json, _} =  Plug.Conn.read_body(conn)
    {:ok, %{"purchase_id" => purchase_id}} = JSON.decode(json)
    TwoTap.confirm_purchase(purchase_id)
    conn
  end

  # TODO: would need to inform the calling application of the final status
  def update_purchase(conn) do
    {:ok, json, _} =  Plug.Conn.read_body(conn)
    JSON.decode(json)
    conn
  end
end
