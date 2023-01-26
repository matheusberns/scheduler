class ChangeCodCliToClients < ActiveRecord::Migration[6.1]
  def change
    rename_column :customers, :cod_cli, :code
  end
end
