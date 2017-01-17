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
    assert %{"sites" => _} = response
  end

  test "start TwoTap purchase" do
    purchase_data = %{"52265d0055a0f915c9000002" => %{ "noauthCheckout"=> %{ "email" => "shopper@gmail.com", "shipping_telephone" => "6503941234", "shipping_zip" => "94303", "shipping_state" => "California", "shipping_city" => "Palo Alto", "shipping_address" => "555 Palo Alto Avenue"}}}
    {:ok, response} = TwoTap.start_purchase({:ok, %{"cart_id" => @cart_id}}, purchase_data)
    assert %{"purchase_id" => _, "message" => _, "description" => _} = response
  end

  test "confirm purchase" do
    {:ok, response} = TwoTap.confirm_purchase("50f414b9e6a4869bf6000010")
    assert %{"purchase_id" => _, "message" => _, "description" => _} = response
  end

  test "checkout" do
    purchase_data = %{"52265d0055a0f915c9000002" => %{ "noauthCheckout"=> %{ "email" => "shopper@gmail.com", "shipping_telephone" => "6503941234", "shipping_zip" => "94303", "shipping_state" => "California", "shipping_city" => "Palo Alto", "shipping_address" => "555 Palo Alto Avenue"}}}
    {:ok, response} = TwoTap.start_purchase({:ok, %{"cart_id" => @cart_id}}, purchase_data)
    assert %{"purchase_id" => _, "message" => _, "description" => _} = response
  end
end
