# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include('must be greater than or equal to 0')
    end
  end

  describe '#mark_as_abandoned' do
    let(:cart) { create(:cart, active: true, abandoned_at: nil) }

    it 'marks the cart as abandoned' do
      expect { cart.mark_as_abandoned }.to change { cart.active }.from(true).to(false)
                                                                 .and change { cart.abandoned_at }.from(nil)
    end
  end

  describe '#remove_if_abandoned' do
    context 'when the cart is abandoned for more than 7 days' do
      let!(:cart) { create(:cart, :abandoned) }

      it 'removes the cart' do
        expect { cart.remove_if_abandoned }.to change { Cart.count }.by(-1)
      end
    end

    context 'when the cart is not abandoned for more than 7 days' do
      let!(:cart) { create(:cart, active: false, abandoned_at: 5.days.ago) }

      it 'does not remove the cart' do
        expect { cart.remove_if_abandoned }.not_to(change { Cart.count })
      end
    end
  end
end
