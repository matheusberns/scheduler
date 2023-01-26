class RenameCnpjCustomerColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :customers, :cnpj, :cpf_cnpj
  end
end
