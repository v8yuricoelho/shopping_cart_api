# frozen_string_literal: true

class CartItem < ApplicationRecord
  after_save :update_cart_total_price
  after_destroy :update_cart_total_price

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
  validates :product, presence: true
  validates :cart, presence: true

  belongs_to :cart
  belongs_to :product

  def total_price
    (quantity * product.price.to_f).round(2)
  end

  private

  def update_cart_total_price
    total = cart.cart_items.joins(:product).sum('cart_items.quantity * products.price')
    cart.update_column(:total_price, total)
  end
end
