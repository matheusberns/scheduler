class ChangeFieldsToOrderItems < ActiveRecord::Migration[6.1]
  def change
    remove_column :order_items, :cod_pro
    remove_column :order_items, :cod_der

    add_reference :order_items, :product, index: true, foreign_key: {to_table: :products}
  end
end
