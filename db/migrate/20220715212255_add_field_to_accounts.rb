class AddFieldToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :billet_file_url_fixed, :boolean, default: false
    add_column :accounts, :invoice_file_url_fixed, :boolean, default: false
  end
end
