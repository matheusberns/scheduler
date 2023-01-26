class CreateUserLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :user_logs do |t|
      t.datetime :date, null: false
      t.string :description, null: false

      t.uuid :uuid, index: true, null: false, default: 'uuid_generate_v4()', unique: true
      t.references :customer, index: true, foreign_key: { to_table: :customers }
      t.references :account, index: true, foreign_key: { to_table: :accounts }
      t.references :user, index: true, foreign_key: { to_table: :users }

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
