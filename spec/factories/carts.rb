# frozen_string_literal: true

FactoryBot.define do
  factory :cart do
    total_price { 0.0 }
    active { true }
    abandoned_at { nil }
  end
end
