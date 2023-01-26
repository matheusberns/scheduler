class CreateStates < ActiveRecord::Migration[6.1]
  def change
    create_table :states do |t|
      t.string :uf, limit: 2, null: false, index: true
      t.string :name, index: true
      t.integer :country, null: false, index: true, default: 1

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
