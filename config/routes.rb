# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :products
  resources :carts, only: %i[create show update] do
    delete '/:product_id', to: 'carts#destroy', on: :collection
  end

  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'rails/health#show'
end
