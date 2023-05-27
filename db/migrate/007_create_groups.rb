# frozen_string_literal: true

class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups, force: true do |t|
      t.string :title

      add_belongs_to :departments, :id, index: true
      add_belongs_to :faculties, :id, index: true

      t.integer :course

      t.datetime :fetched_at
    end
  end
end
