class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.datetime :budget_date, null: false
      t.integer :order_number
      t.datetime :order_date, null: false
      t.float :value, null: false
      t.integer :situation
      t.string :purchase_order, limit: 255
      t.integer :freight_type, null: false
      t.text :delivery_address, null: false
      t.float :freight_value
      t.datetime :delivery_forecast
      t.string :cod_tra
      t.string :cod_cpg
      t.string :cod_cli

      t.references :account, index: true, foreign_key: { to_table: :accounts }

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
