defmodule TwoTap.HTTPClient do
  @public_token Application.get_env(:two_tap, :public_token)
  @private_token Application.get_env(:two_tap, :private_token)
  @purchase_callback Application.get_env(:two_tap, :purchase_callback)

  def create_cart(products) do
    HTTPoison.post("https://api.twotap.com/v1.0/cart", to_json([products: products]), [{"Content-Type", "application/json"}], [params: [public_token: @public_token, test_mode: "dummy_data"]])
  end

  def get_cart_status(cart_id) do
    HTTPoison.get("https://api.twotap.com/v1.0/cart/status", [], [params: [public_token: @public_token, cart_id: cart_id, test_mode: "dummy_data"]])
  end

  def start_purchase(cart_id, purchase_data) do
    HTTPoison.post("https://api.twotap.com/v1.0/purchase", to_json([fields_input: purchase_data]), [{"Content-Type", "application/json"}], [params: [public_token: @public_token, cart_id: cart_id, confirm: @purchase_callback, test_mode: "dummy_data"]])
  end

  def confirm_purchase(purchase_id) do
    HTTPoison.post("https://api.twotap.com/v1.0/purchase/confirm", [], [], [params: [private_token: @private_token, purchase_id: purchase_id, test_mode: "fake_confirm"]])
  end

  defp to_json(data) do
    {:ok, json} = JSON.encode(data)
    json
  end
end
