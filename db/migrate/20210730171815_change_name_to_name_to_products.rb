class ChangeNameToNameToProducts < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :des_pro, :name
    change_column :products, :name, :string, null: true
    change_column :products, :derivation, :string, null: true
  end
end
