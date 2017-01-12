defmodule TwoTap.ClientTest do
  use ExUnit.Case

  test "creating TwoTap cart" do
    products = ["http://twotapstore.com/vented-flat-front-shorts/", "http://twotapstore.com/crinkled-satin-halter-dress/"]
    {:ok, response} = TwoTap.Client.create_cart(products)
    assert %{"cart_id" => _, "message" => _, "description" => _} = response
  end

end
