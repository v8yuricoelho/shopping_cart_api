# frozen_string_literal: true

class CartsController < ApplicationController
  def create
    current_cart = find_or_create_cart
    cart_item = current_cart.cart_items.find_or_initialize_by(product: product)
    cart_item.quantity += cart_item_params[:quantity].to_i if cart_item.persisted?

    if cart_item.save
      render json: CartSerializer.new(current_cart).serialize, status: :ok
    else
      render json: { error: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    if current_cart
      render json: CartSerializer.new(current_cart).serialize, status: :ok
    else
      render json: { error: 'No active cart found' }, status: :not_found
    end
  end

  def update
    cart_item = find_cart_item

    if update_quantity(cart_item, params[:quantity].to_i)
      render json: CartSerializer.new(current_cart).serialize, status: :ok
    else
      render json: { error: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    cart_item = find_cart_item

    if cart_item.nil?
      render json: { error: 'Product not found in cart' }, status: :not_found
    else
      cart_item.destroy
      render json: CartSerializer.new(current_cart).serialize, status: :ok
    end
  end

  private

  def product
    @product ||= Product.find(params[:product_id]) || (raise ActiveRecord::RecordNotFound, 'Product not found')
  end

  def current_cart
    return unless session[:cart_id]

    Cart.find(session[:cart_id])
  end

  def find_or_create_cart
    current_cart || create_cart
  end

  def create_cart
    cart = Cart.create!(total_price: 0)
    session[:cart_id] = cart.id
    cart
  end

  def update_quantity(cart_item, quantity)
    return false unless cart_item

    if quantity <= 0
      cart_item.destroy
    else
      cart_item.update(quantity: quantity)
    end
  end

  def find_cart_item
    current_cart.cart_items.find_by(product_id: product.id)
  end

  def cart_item_params
    params.permit(:product_id, :quantity)
  end
end
