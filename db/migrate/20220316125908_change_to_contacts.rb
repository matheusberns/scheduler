class ChangeToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :email, :string
    rename_column :contacts, :cpf_cnpj, :cpf

  end
end
