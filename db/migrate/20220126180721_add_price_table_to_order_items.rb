class AddPriceTableToOrderItems < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items, :price_table, :string
    add_column :order_items, :product_code, :string
  end
end
