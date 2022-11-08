# frozen_string_literal: true

class ChangeUsersUidColumnToLongType < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :uid, :bigint
  end
end
