class AddPortalAccountToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :portal_account, :string
  end
end
