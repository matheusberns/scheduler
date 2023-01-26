class CreateOrderInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :order_invoices do |t|
      t.uuid :uuid, index: true, null: false, default: 'uuid_generate_v4()', unique: true
      t.references :order, index: true, foreign_key: { to_table: :orders }
      t.references :invoice, index: true, foreign_key: { to_table: :invoices }
      t.references :account, index: true, foreign_key: { to_table: :accounts }

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
