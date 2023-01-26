# frozen_string_literal: true

class CreateUserNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :user_notifications do |t|
      t.references :user, index: true, foreign_key: { to_table: :users }

      t.text :message
      t.boolean :seen, null: false, default: false

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
