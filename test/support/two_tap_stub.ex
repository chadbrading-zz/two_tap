defmodule TwoTap.Stub do
  def create_cart(_products) do
    Poison.decode("{\"cart_id\":\"58780e90e2205404b49791b9\",\"message\":\"still_processing\",\"description\":\"Cart is processing.\"}")
  end

  def get_cart_status(_cart_id) do
    {:ok, json} = File.read("test/support/cart_status.txt")
    Poison.decode(json)
  end

  def start_purchase(_cart_id, _purchase_data) do
    Poison.decode("{\"description\":\"Still processing\",\"message\":\"still_processing\",\"purchase_id\":\"50f414b9e6a4869bf6000010\"}")
  end

  def confirm_purchase(_purchase_id) do
    Poison.decode("{\"description\":\"Still processing\",\"message\":\"still_processing\",\"purchase_id\":\"50f414b9e6a4869bf6000010\"}")
  end
end
