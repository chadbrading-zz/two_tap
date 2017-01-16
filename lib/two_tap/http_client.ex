defmodule TwoTap.HTTPClient do
  @public_token Application.get_env(:two_tap, :public_token)
  @private_token Application.get_env(:two_tap, :private_token)
  @confirm_purchase_callback Application.get_env(:two_tap, :confirm_purchase_callback)
  @update_purchase_callback Application.get_env(:two_tap, :update_purchase_callback)

  def create_cart(products) do
    HTTPoison.post("https://api.twotap.com/v1.0/cart", to_json([products: products]), [{"Content-Type", "application/json"}], [params: [public_token: @public_token, test_mode: "dummy_data"]])
  end

  def get_cart_status(cart_id) do
    HTTPoison.get("https://api.twotap.com/v1.0/cart/status", [], [params: [public_token: @public_token, cart_id: cart_id, test_mode: "dummy_data"]])
  end

  def start_purchase(cart_id, purchase_data) do
    HTTPoison.post("https://api.twotap.com/v1.0/purchase", to_json([fields_input: purchase_data]), [{"Content-Type", "application/json"}], [params: [public_token: @public_token, cart_id: cart_id, confirm: to_json(purchase_callbacks), test_mode: "dummy_data"]])
  end

  def confirm_purchase(purchase_id) do
    HTTPoison.post("https://api.twotap.com/v1.0/purchase/confirm", [], [], [params: [private_token: @private_token, purchase_id: purchase_id, test_mode: "fake_confirm"]])
  end

  defp to_json(data) do
    {:ok, json} = JSON.encode(data)
    json
  end

  defp purchase_callbacks do
    %{method: "http", http_confirm_url: @confirm_purchase_callback, http_update_url: @update_purchase_callback}
  end
end
