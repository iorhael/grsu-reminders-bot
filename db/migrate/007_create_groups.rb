# frozen_string_literal: true

class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups, force: true do |t|
      t.string :title

      t.belongs_to :department, index: true
      t.belongs_to :faculty, index: true

      t.integer :course

      t.datetime :fetched_at
    end
  end
end
