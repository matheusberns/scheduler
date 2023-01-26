class AddTableTools < ActiveRecord::Migration[6.1]
  def change
    create_table :tools do |t|
      t.string :name, index: true, null: false
      t.string :slug
      t.string :icon
      t.integer :tool_type
      t.integer :tool_code, null: false, unique: true
      t.boolean :is_chat, default: false
      t.boolean :is_attendance, default: false
      t.boolean :is_extension, default: false
      t.boolean :only_admin, default: false
      t.boolean :is_post_office, default: false, null: false
      t.boolean :is_flat_icon, default: false
      t.uuid :uuid, default: 'gen_random_uuid()', index: true,  unique: true

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
