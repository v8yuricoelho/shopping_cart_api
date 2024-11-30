# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :products
  resources :carts, only: %i[create show]

  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'rails/health#show'
end
