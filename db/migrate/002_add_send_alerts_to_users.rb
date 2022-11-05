# frozen_string_literal: true

class AddSendAlertsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :receive_alerts, :boolean
  end
end
