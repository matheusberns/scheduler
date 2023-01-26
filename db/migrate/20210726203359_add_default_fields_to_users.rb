class AddDefaultFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :created_by_id, :integer
    add_column :users, :updated_by_id, :integer
  end
end
