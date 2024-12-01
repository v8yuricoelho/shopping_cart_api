# frozen_string_literal: true

require 'sidekiq-scheduler'

class ManageAbandonedCartsJob
  include Sidekiq::Worker

  def perform
    mark_abandoned_carts
    delete_old_abandoned_carts
  end

  private

  def mark_abandoned_carts
    Cart.where(active: true).where('updated_at < ?', 3.hours.ago).find_each do |cart|
      cart.update(active: false)
      Rails.logger.info "Cart ##{cart.id} marked as abandoned"
    end
  end

  def delete_old_abandoned_carts
    Cart.where(active: false).where('updated_at < ?', 7.days.ago).find_each do |cart|
      cart.destroy
      Rails.logger.info "Cart ##{cart.id} deleted (abandoned for more than 7 days)"
    end
  end
end
