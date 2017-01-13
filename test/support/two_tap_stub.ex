defmodule TwoTap.Stub do
  def create_cart(products) do
    {:ok, %HTTPoison.Response{body: "{\"cart_id\":\"58780e90e2205404b49791b9\",\"message\":\"still_processing\",\"description\":\"Cart is processing.\"}"}
  end

  def get_cart_status(cart_id) do
    {:ok, json} = File.read("cart_status.txt")
    {:ok, %HTTPoison.Response{body: json}}
  end
end
