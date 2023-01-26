class CreateBudgetItems < ActiveRecord::Migration[6.1]
  def change
    create_table :budget_items do |t|
      t.integer :quantity, null: false, default: 0

      t.uuid :uuid, index: true, null: false, default: 'uuid_generate_v4()', unique: true
      t.references :product_derivation, index: true, foreign_key: { to_table: :product_derivations }
      t.references :product, index: true, foreign_key: { to_table: :products }
      t.references :budget, index: true, foreign_key: { to_table: :budgets }
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
