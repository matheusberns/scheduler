class AddCpfToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :cpf, :string, index: true
  end
end
