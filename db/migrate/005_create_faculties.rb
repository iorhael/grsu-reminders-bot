# frozen_string_literal: true

class CreateFaculties < ActiveRecord::Migration[7.0]
  def change
    create_table :faculties, force: true do |t|
      t.string :title, null: false

      t.datetime :fetched_at
    end
  end
end
