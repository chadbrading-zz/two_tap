defmodule TwoTap.Callbacks do
  def confirm_purchase(conn) do
    conn
    |> get_checkout_worker
    |> GenServer.cast(:confirm_purchase)
    conn
  end

  def update_purchase(conn) do
    conn
    |> get_checkout_worker
    |> GenServer.cast(:purchase_complete)
    conn
  end

  defp get_checkout_worker(conn) do
    {:ok, json, _} =  Plug.Conn.read_body(conn)
    {:ok, %{"purchase_id" => purchase_id}} = JSON.decode(json)
    [{^purchase_id, pid}] = :ets.lookup(:checkout_registry, purchase_id)
    pid
  end
end
