# frozen_string_literal: true

class CartsController < ApplicationController
  # rubocop:disable Metrics/AbcSize
  def create
    cart_item = current_cart.cart_items.find_or_initialize_by(product: product)
    cart_item.quantity += cart_item_params[:quantity].to_i if cart_item.persisted?

    if cart_item.save
      render json: CartSerializer.new(current_cart).serialize, status: :ok
    else
      render json: { error: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def product
    @product ||= Product.find(params[:product_id])
  end

  def current_cart
    @current_cart ||= if session[:cart_id]
                        Cart.find(session[:cart_id])
                      else
                        cart = Cart.create!(total_price: 0)
                        session[:cart_id] = cart.id
                        cart
                      end
  end

  def cart_item_params
    params.permit(:product_id, :quantity)
  end
end
