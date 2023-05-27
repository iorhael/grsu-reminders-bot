# frozen_string_literal: true

class CreateTeachers < ActiveRecord::Migration[7.0]
  def change
    create_table :teachers, force: true do |t|
      t.string :name
      t.string :surname
      t.string :patronym

      t.string :post

      t.string :phone
      t.string :descr
      t.string :email
      t.string :skype

      t.datetime :fetched_at
    end
  end
end
