class ChangeNameFieldsToProducts < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :name, :des_pro
  end
end