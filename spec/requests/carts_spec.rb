# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/carts', type: :request do
  let!(:cart) { create(:cart) }
  let!(:product) { create(:product, name: 'Test Product', price: 10.0) }

  before do
    allow_any_instance_of(CartsController).to receive(:current_cart).and_return(cart)
  end

  describe 'POST /carts (create)' do
    context 'when the product already exists in the cart' do
      let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

      it 'updates the quantity of the existing item in the cart' do
        expect do
          post '/carts', params: { product_id: product.id, quantity: 1 }, as: :json
        end.to change { cart_item.reload.quantity }.by(1)
      end
    end

    context 'when the product does not exist in the cart' do
      it 'adds a new item to the cart' do
        expect do
          post '/carts', params: { product_id: product.id, quantity: 2 }, as: :json
        end.to change { cart.cart_items.count }.by(1)
      end
    end
  end

  describe 'GET /carts (show)' do
    it 'returns the cart details' do
      get "/carts/#{product.id}", as: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(cart.id)
    end

    context 'when there is no active cart' do
      before { allow_any_instance_of(CartsController).to receive(:current_cart).and_return(nil) }

      it 'returns an error' do
        get "/carts/#{product.id}", as: :json
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('No active cart found')
      end
    end
  end

  describe 'PATCH /carts (update)' do
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    it 'updates the quantity of an existing item' do
      patch "/carts/#{product.id}", params: { product_id: product.id, quantity: 3 }, as: :json
      expect(response).to have_http_status(:ok)
      expect(cart_item.reload.quantity).to eq(3)
    end
  end

  describe 'DELETE /carts (destroy)' do
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    it 'removes the item from the cart' do
      expect do
        delete "/carts/#{product.id}", params: { product_id: product.id }, as: :json
      end.to change { cart.cart_items.count }.by(-1)
    end
  end
end
