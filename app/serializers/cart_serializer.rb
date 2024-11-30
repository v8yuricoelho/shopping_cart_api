# frozen_string_literal: true

class CartSerializer
  def initialize(cart)
    @cart = cart
  end

  def serialize
    {
      id: @cart.id,
      products: format_products,
      total_price: @cart.total_price.to_f.round(2)
    }
  end

  private

  def format_products
    @cart.cart_items.map do |item|
      {
        id: item.product.id,
        name: item.product.name,
        quantity: item.quantity,
        unit_price: unit_price(item),
        total_price: item.total_price
      }
    end
  end

  def unit_price(item)
    item.product.price.to_f.round(2)
  end
end
