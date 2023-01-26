class CreateExternalServices < ActiveRecord::Migration[6.1]
  def change
    create_table :external_services do |t|
      t.string :name, null: false
      t.integer :integration_type, default: 1
      t.string :base_url
      t.text :parameters
      t.text :text

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