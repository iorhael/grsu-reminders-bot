# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, force: true do |t|
      t.integer :uid
    end
  end
end
