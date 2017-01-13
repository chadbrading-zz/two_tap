defmodule TwoTap do
  use Application
  @two_tap_api Application.get_env(:two_tap, :two_tap_api)

  def start(_type, _args) do
    import Supervisor.Spec, warn: :false

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, TwoTap.Router, [], [port: 4004])
    ]

    opts = [strategy: :one_for_one, name: TwoTap.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def create_cart(products) do
    @two_tap_api.create_cart(products)
    |> parse_response
  end

  # may need to get site_id in order to make purchase
  def get_cart_status(cart_id) do
    @two_tap_api.get_cart_status(cart_id)
    |> parse_response

  end

  defp parse_response(response) do
    case response do
      {:ok, %HTTPoison.Response{body: body}} ->
        JSON.decode(body)
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %{"reason" => reason}}
    end
  end
end
