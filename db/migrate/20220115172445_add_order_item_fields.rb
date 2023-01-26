class AddOrderItemFields < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items, :purchase_order, :string
    add_column :order_items, :unit_price, :float
    add_column :order_items, :final_value, :float
    add_column :order_items, :fcp_value, :float
    add_column :order_items, :ics_value, :float
    add_column :order_items, :ipi_percentage, :float
    add_column :order_items, :situation_item, :integer
  end
end
