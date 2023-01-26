class ChangeOrderColumnOrderDate < ActiveRecord::Migration[6.1]
  def change
    change_column :orders, :order_date, :datetime, null: true
  end
end
