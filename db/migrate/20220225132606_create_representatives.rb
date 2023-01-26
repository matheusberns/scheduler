class CreateRepresentatives < ActiveRecord::Migration[6.1]
  def change
    create_table :representatives do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.string :email

      t.uuid :uuid, index: true, null: false, default: 'uuid_generate_v4()', unique: true

      t.references :account, index: true, foreign_key: { to_table: :accounts }
      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
