class AddUidPasswdToExternalServices < ActiveRecord::Migration[6.1]
  def change
    add_column :external_services, :uid_access, :string
    add_column :external_services, :password, :string
    add_column :external_services, :auth_key, :string
  end
end
