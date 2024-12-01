# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartsController, type: :routing do
  describe 'routes' do
    it 'routes to #show' do
      expect(get: '/carts/1').to route_to('carts#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/carts').to route_to('carts#create')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/carts/1').to route_to('carts#update', id: '1')
    end

    it 'routes to #destroy via DELETE with product_id' do
      expect(delete: '/carts/1').to route_to('carts#destroy', product_id: '1')
    end
  end
end
