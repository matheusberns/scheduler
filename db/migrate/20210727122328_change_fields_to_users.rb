class ChangeFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :notification_token
    remove_column :users, :created_by_id
    remove_column :users, :updated_by_id
    add_reference :users, :created_by, index: true, foreign_key: {to_table: :users}
    add_reference :users, :updated_by, index: true, foreign_key: {to_table: :users}
    add_column :users, :is_blocked, :boolean, default: false
    add_column :users, :is_account_admin, :boolean, default: false
    add_column :users, :last_request_at, :datetime
    add_column :users, :remember_created_at, :datetime
    add_column :users, :timeout_in, :integer
    add_column :users, :allow_password_change, :boolean, default: false
    add_column :users, :is_integrator, :boolean, default: false
    remove_column :users, :tokens
    add_column :users, :tokens, :json, default: '{}'
  end
end
