class CreateProductDerivations < ActiveRecord::Migration[6.1]
  def change
    create_table :product_derivations do |t|
      t.string :code, null: false
      t.float :multiple_quantity, default: 0

      t.references :product, index: true, foreign_key: { to_table: :products }
      t.references :account, index: true, foreign_key: { to_table: :accounts }
      t.uuid :uuid, index: true, null: false, default: 'uuid_generate_v4()', unique: true

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
