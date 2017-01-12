defmodule TwoTap.Client do
  @public_token Application.get_env(:two_tap, :public_token)

  def create_cart(products) do
    case HTTPoison.post("https://api.twotap.com/v1.0/cart",
                        encode([products: products]),
                        [{"Content-Type", "application/json"}],
                        [params: [public_token: @public_token]]) do
      {:ok, %HTTPoison.Response{body: body}} ->
        JSON.decode(body)
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %{"reason" => reason}}
    end
  end
end
