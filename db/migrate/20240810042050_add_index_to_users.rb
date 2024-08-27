# frozen_string_literal: true

class AddIndexToUsers < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :name, unique: true
    add_index :users, :email, unique: true
  end
end
