class ChangeDefaultValueToValueColumns < ActiveRecord::Migration[6.1]
  def change
    change_column :invoice_items, :value, :float, default: 0.0
    change_column :invoices, :total_value, :float, default: 0.0
    change_column :securities, :value, :float, default: 0.0
    change_column :orders, :value, :float, default: 0.0
    change_column :orders, :freight_value, :float, default: 0.0
  end
end
