class AddBaseUrlToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :base_url, :string
    add_column :accounts, :timeout_in, :integer
    add_column :accounts, :is_active_directory, :boolean, default: false
    add_column :accounts, :active_directory_host, :string
    add_column :accounts, :smtp_user, :string
    add_column :accounts, :smtp_password, :string
    add_column :accounts, :smtp_host, :string
    add_column :accounts, :smtp_email, :string
    add_column :accounts, :imap_host, :string
    add_column :accounts, :imap_user, :string
    add_column :accounts, :imap_password, :string
    add_column :accounts, :velow_account, :string
    add_column :accounts, :active_directory_base, :string
    add_column :accounts, :active_directory_domain, :string
    add_column :accounts, :force_modify_password, :boolean, default: false
    add_column :accounts, :imap_ssl, :boolean, default: true

  end
end
