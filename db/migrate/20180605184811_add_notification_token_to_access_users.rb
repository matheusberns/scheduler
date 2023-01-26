# frozen_string_literal: true

class AddNotificationTokenToAccessUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :notification_token, :string, null: true
  end
end
