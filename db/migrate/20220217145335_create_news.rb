class CreateNews < ActiveRecord::Migration[6.1]
  def change
    create_table :news do |t|
      t.string :title, null: false
      t.text :description
      t.string :url
      t.string :url_description

      t.uuid :uuid, index: true, null: false, default: 'uuid_generate_v4()', unique: true

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
