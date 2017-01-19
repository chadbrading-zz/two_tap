defmodule TwoTap.CheckoutWorkerTest do
  use ExUnit.Case

  @cart_id "58780e90e2205404b49791b9"
  @purchase_id "50f414b9e6a4869bf6000010"

  setup do
    {:ok, pid} = TwoTap.CheckoutWorker.start_link("chan", "tag", "redel", "{\"purchase_data\":\"foo\",\"products\":\"http://twotapstore.com/distressed-skinny-jeans/\"}")
    {:ok, [pid: pid]}
  end

  test "initializes state with cart_id and purchase data", context do
    pid = context.pid
    {:ok, checkout_status} = GenServer.call(pid, :checkout_status)

    assert checkout_status.cart_id == @cart_id
    assert checkout_status.purchase_data == "foo"
  end

  test "stores cart_id and pid in ets", context do
    pid = context.pid

    [{{:cart_id, _ }, ets_pid}] = :ets.lookup(:checkout_registry, {:cart_id, @cart_id})
    assert pid == ets_pid
  end

  test "start purchase stores purchase_id to state", context do
    pid = context.pid
    GenServer.cast(pid, :start_purchase)

    {:ok, checkout_status} = GenServer.call(pid, :checkout_status)
    assert checkout_status.purchase_id ==  @purchase_id
  end

  test "start purchase adds purchase_id and removes cart_id from ets", context do
    pid = context.pid
    GenServer.cast(pid, :start_purchase)
    GenServer.call(pid, :checkout_status)

    [{{:purchase_id, _ }, ets_pid}] = :ets.lookup(:checkout_registry, {:purchase_id, @purchase_id})
    assert pid == ets_pid

    assert []  == :ets.lookup(:checkout_registry, {:cart_id, @cart_id})
  end
end
