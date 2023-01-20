class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false, index: true
      t.string :base_url
      t.string :smtp_user
      t.string :smtp_password
      t.string :smtp_host
      t.string :smtp_email
      t.boolean :force_modify_password, default: false
      t.boolean :imap_ssl, default: true

      t.uuid :uuid, index: true, null: false, default: 'uuid_generate_v4()', unique: true

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true

      t.references :created_by, index: true, foreign_key: {to_table: :users}
      t.references :updated_by, index: true, foreign_key: {to_table: :users}

      t.json :primary_color
      t.json :primary_colors, array: true
      t.json :secondary_color
      t.json :secondary_colors, array: true

      t.timestamps
    end
  end
end
