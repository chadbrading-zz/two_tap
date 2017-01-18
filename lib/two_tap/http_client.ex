defmodule TwoTap.HTTPClient do
  @public_token Application.fetch_env!(:two_tap, :public_token)
  @private_token Application.fetch_env!(:two_tap, :private_token)
  @confirm_purchase_callback Application.fetch_env!(:two_tap, :confirm_purchase_callback)
  @update_purchase_callback Application.fetch_env!(:two_tap, :update_purchase_callback)
  @two_tap_url "https://api.twotap.com/v1.0"

  def request(method, endpoint, body, headers, opts \\ [], retries_left \\ 3) do
    case HTTPoison.request(method, @two_tap_url <> endpoint, to_json(body), headers, opts) do
      {:ok, %HTTPoison.Response{body: body}} ->
        Poison.decode(body)
      {:error, %HTTPoison.Error{reason: reason}} ->
        if retries_left > 0 do
          :timer.sleep(2000)
          request(method, endpoint, body, headers, opts, retries_left - 1)
        else
          {:error, %{"reason" => reason}}
        end
    end
  end

  def create_cart(products) do
    request(:post, "/cart", %{products: products, public_token: @public_token, test_mode: "dummy_data"}, [{"Content-Type", "application/json"}])
  end

  def get_cart_status(cart_id) do
    request(:get, "/cart/status", [], [], %{params: %{public_token: @public_token, cart_id: cart_id, test_mode: "dummy_data"}})
  end

  def start_purchase(cart_id, purchase_data) do
    request(:post, "/purchase", %{cart_id: cart_id, fields_input: purchase_data, confirm: purchase_callbacks, test_mode: "dummy_data", public_token: @public_token}, [{"Content-Type", "application/json"}])
  end

  def confirm_purchase(purchase_id) do
    request(:post, "/purchase/confirm", %{private_token: @private_token, purchase_id: purchase_id, test_mode: "fake_confirm"}, [{"Content-Type", "application/json"}])
  end

  defp to_json(data) do
    {:ok, json} = Poison.encode(data)
    json
  end

  defp purchase_callbacks do
    %{method: "http", http_confirm_url: @confirm_purchase_callback, http_update_url: @update_purchase_callback}
  end
end
