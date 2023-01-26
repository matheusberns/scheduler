class AddOrdersToOrderItems < ActiveRecord::Migration[6.1]
  def change
    add_reference :order_items, :order, index: true, foreign_key: {to_table: :orders}
  end
end
