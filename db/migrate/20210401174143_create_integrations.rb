class CreateIntegrations < ActiveRecord::Migration[5.2]
  def change
    create_table :integrations do |t|
      t.string :token, null: false
      t.string :description
      t.integer :integration_type, null: false

      t.references :account, index: true, foreign_key: { to_table: :accounts }
      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
