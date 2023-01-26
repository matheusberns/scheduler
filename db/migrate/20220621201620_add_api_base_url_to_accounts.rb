class AddApiBaseUrlToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :api_base_url, :string
  end
end

