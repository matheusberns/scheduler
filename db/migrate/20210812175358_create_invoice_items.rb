class CreateInvoiceItems < ActiveRecord::Migration[6.1]
  def change
    create_table :invoice_items do |t|
      t.integer :sequence, null: false
      t.float :value, null: false

      t.uuid :uuid, index: true, null: false, default: 'uuid_generate_v4()', unique: true
      t.references :customer, index: true, foreign_key: { to_table: :customers }
      t.references :account, index: true, foreign_key: { to_table: :accounts }
      t.references :invoice, index: true, foreign_key: { to_table: :invoices }

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
