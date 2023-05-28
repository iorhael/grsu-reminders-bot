# frozen_string_literal: true

class RenameUsersReceiveAlertsToNotificate < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :receive_alerts, :notificate
  end
end
