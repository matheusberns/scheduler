class AddColorsToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :primary_color, :json
    add_column :accounts, :primary_colors, :json, array: true
    add_column :accounts, :secondary_color, :json
    add_column :accounts, :secondary_colors, :json, array: true
  end
end
