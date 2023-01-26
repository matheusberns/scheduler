class AddNameAndPhoneToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :name, :string
    add_column :contacts, :phone, :string
  end
end
