class RemoveDeliveryAddressToOrders < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :delivery_address
  end
end
