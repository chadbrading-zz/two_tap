defmodule TwoTap.Callbacks do
  def start_purchase(conn) do
    conn
    |> get_checkout_worker(:cart_id)
    |> GenServer.cast(:start_purchase)
  end

  def confirm_purchase(conn) do
    conn
    |> get_checkout_worker(:purchase_id)
    |> GenServer.cast(:confirm_purchase)
    conn
  end

  def purchase_complete(conn) do
    conn
    |> get_checkout_worker(:purchase_id)
    |> GenServer.cast(:purchase_complete)
    conn
  end

  defp get_checkout_worker(conn, lookup_field) do
    {:ok, json, _} =  Plug.Conn.read_body(conn)
    lookup_field_string = Atom.to_string(lookup_field)
    {:ok, %{^lookup_field_string => lookup_id}} = Poison.decode(json)
    [{{^lookup_field, ^lookup_id}, pid}] = :ets.lookup(:checkout_registry, {lookup_field, lookup_id})
    pid
  end
end
