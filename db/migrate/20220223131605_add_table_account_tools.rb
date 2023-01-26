class AddTableAccountTools < ActiveRecord::Migration[6.1]
  def change
    create_table :account_tools do |t|
      t.references :account, index: true, foreign_key: { to_table: :accounts }
      t.references :tool, index: true, foreign_key: { to_table: :tools }

      t.uuid :uuid, index: true, null: false, default: 'gen_random_uuid()'

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
