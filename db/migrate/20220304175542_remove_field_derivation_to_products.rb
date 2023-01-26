class RemoveFieldDerivationToProducts < ActiveRecord::Migration[6.1]
  def change
    remove_column :products, :derivation
  end
end
