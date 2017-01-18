defmodule TwoTap.CheckoutWorker do
  use GenServer

  def start_link(channel, tag, redelivered, payload) do
    GenServer.start_link(__MODULE__, [channel, tag, redelivered, payload])
  end

  def init([channel, tag, _redelivered, %{"products" => products, "purchase_data" => purchase_data}]) do
    try do
      case TwoTap.checkout(products, purchase_data) do
        {:ok, %{"purchase_id" => purchase_id}} ->
          :ets.insert(:checkout_registry, {purchase_id, self})
          AMQP.Basic.ack channel, tag
          {:ok, %{purchase_id: purchase_id}}
        {:ok, %{"message" => "not_found"}} ->
          IO.puts "cart not found"
          AMQP.Basic.reject channel, tag, requeue: false
          {:stop}
      end
    rescue
      exception ->
        AMQP.Basic.reject channel, tag, requeue: false
        IO.puts "Error starting checkout"
        IO.puts "excpetion: "
        IO.inspect exception
        {:stop}
    end
  end

  def init([channel, tag, redelivered, payload]) do
    {:ok, data} = Poison.decode(payload)
    init([channel, tag, redelivered, data])
  end

  def handle_cast(:confirm_purchase, %{purchase_id: purchase_id}) do
    TwoTap.confirm_purchase(purchase_id)
    {:noreply, %{purchase_id: purchase_id}}
  end

  # TODO: would need to inform the calling application of the final status
  def handle_cast(:purchase_complete, %{purchase_id: purchase_id}) do
    :ets.delete(:checkout_registry, purchase_id)
    {:stop, :normal}
  end
end
