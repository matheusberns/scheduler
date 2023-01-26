class CreateInstallments < ActiveRecord::Migration[6.1]
  def change
    create_table :installments do |t|
      t.string :serial_number, null: false, index: true
      t.string :invoice_number, null: false, index: true
      t.string :code
      t.string :billing_number, null: false, index: true
      t.string :billing_type, null: false, index: true
      t.string :expiration
      t.string :value

      t.uuid :uuid, index: true, null: false, default: 'uuid_generate_v4()', unique: true
      t.references :customer, index: true, foreign_key: { to_table: :customers }
      t.references :account, index: true, foreign_key: { to_table: :accounts }
      t.references :invoice, index: true, foreign_key: {to_table: :invoices}

      t.references :created_by, index: true, foreign_key: {to_table: :users}
      t.references :updated_by, index: true, foreign_key: {to_table: :users}

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true

      t.timestamps    end
  end
end
