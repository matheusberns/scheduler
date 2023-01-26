class ChangeFieldsToProducts < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :cod_pro, :code
    rename_column :products, :cod_der, :derivation
  end
end
