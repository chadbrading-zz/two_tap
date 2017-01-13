defmodule TwoTapTest do
  use ExUnit.Case
  @cart_id "5851d2992546f9b908e5b694"

  test "create TwoTap cart" do
    products = ["http://twotapstore.com/vented-flat-front-shorts/", "http://twotapstore.com/crinkled-satin-halter-dress/"]
    {:ok, response} = TwoTap.create_cart(products)
    assert %{"cart_id" => _, "message" => _, "description" => _} = response
  end

  test "get TwoTap cart status" do
    {:ok, response} = TwoTap.get_cart_status(@cart_id)
    assert %{} = response
  end
end
