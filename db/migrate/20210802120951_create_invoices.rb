class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.string :invoice_number, null: false
      t.float :total_value, null: false
      t.date :emission_date, null: false
      t.integer :invoice_type, null: false
      t.integer :status

      t.uuid :uuid, index: true, null: false, default: 'uuid_generate_v4()', unique: true
      t.references :customer, index: true, foreign_key: { to_table: :customers }
      t.references :account, index: true, foreign_key: { to_table: :accounts }

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
