class CreatePaymentConditions < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_conditions do |t|
      t.string :name, null: false
      t.string :cod_cpg, null: false

      t.references :account, index: true, foreign_key: { to_table: :accounts }

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
