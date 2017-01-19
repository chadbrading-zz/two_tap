defmodule TwoTap.CheckoutWorker do
  use GenServer
  require Logger

  @amqp Application.fetch_env!(:two_tap, :amqp)

  def start_link(channel, tag, redelivered, payload) do
    GenServer.start_link(__MODULE__, [channel, tag, redelivered, payload])
  end

  def init([channel, tag, _redelivered, payload]) do
    {:ok, %{"products" => products, "purchase_data" => purchase_data}} = Poison.decode(payload)
    try do
      {:ok, %{"cart_id" => cart_id}} = TwoTap.create_cart(products)
      :ets.insert(:checkout_registry, {{:cart_id, cart_id}, self})
      @amqp.Basic.ack channel, tag
      Logger.info("cart created")
      {:ok, %{cart_id: cart_id, purchase_data: purchase_data}}
    rescue
      exception ->
        @amqp.Basic.reject channel, tag, requeue: false
        Logger.info """
        error starting checkout
        exception: #{inspect(exception)}
        """
        {:stop}
    end
  end

  def handle_call(:checkout_status, _from, checkout_state) do
    {:reply, {:ok, checkout_state}, checkout_state}
  end

  def handle_cast(:start_purchase, %{cart_id: cart_id, purchase_data: purchase_data} = state) do
    {:ok, %{"purchase_id" => purchase_id}} = TwoTap.start_purchase(cart_id, purchase_data)
    :ets.insert(:checkout_registry, {{:purchase_id, purchase_id}, self})
    :ets.delete(:checkout_registry, {:cart_id, cart_id})
    Logger.info("purchase started")
    {:noreply, Map.put(state, :purchase_id, purchase_id)}
  end

  def handle_cast(:confirm_purchase, %{purchase_id: purchase_id} = state) do
    TwoTap.confirm_purchase(purchase_id)
    Logger.info("purchase confirmed")
    {:noreply, state}
  end

  # may need to inform the calling application of the final status
  def handle_cast(:purchase_complete, %{purchase_id: purchase_id}) do
    :ets.delete(:checkout_registry, {:purchase_id, purchase_id})
    Logger.info("purchase complete")
    {:stop, :normal}
  end
end
