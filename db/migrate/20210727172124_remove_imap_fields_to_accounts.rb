class RemoveImapFieldsToAccounts < ActiveRecord::Migration[6.1]
  def change
    remove_column :accounts, :imap_host
    remove_column :accounts, :imap_user
    remove_column :accounts, :imap_password
    remove_column :accounts, :velow_account
  end
end
