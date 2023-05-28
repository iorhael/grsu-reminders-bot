# frozen_string_literal: true

class UpdateUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :department_id, :integer
    add_column :users, :faculty_id, :integer
    add_column :users, :group_id, :integer
  end
end
