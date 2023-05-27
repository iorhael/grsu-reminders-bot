# frozen_string_literal: true

class CreateLessons < ActiveRecord::Migration[7.0]
  def change
    create_table :lessons, force: true do |t|
      t.datetime :start
      t.datetime :end

      t.string :type
      t.string :title
      t.string :address
      t.string :room
      t.json :subgroup

      t.belongs_to :teacher, index: true
      t.belongs_to :group, index: true

      t.datetime :fetched_at
    end
  end
end
