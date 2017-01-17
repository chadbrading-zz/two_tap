defmodule TwoTap.CheckoutWorker do
  use GenServer

  def start_link(data) do
    GenServer.start_link(__MODULE__, data)
  end

  def init(%{products: products, purchase_data: purchase_data}) do
    {:ok, %{"purchase_id" => purchase_id}} = TwoTap.checkout(products, purchase_data)
    :ets.insert(:checkout_registry, {purchase_id, self})
    {:ok, %{purchase_id: purchase_id}}
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
