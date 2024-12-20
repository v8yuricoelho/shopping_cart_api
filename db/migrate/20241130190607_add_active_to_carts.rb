# frozen_string_literal: true

class AddActiveToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :active, :boolean, default: true, null: false
  end
end
