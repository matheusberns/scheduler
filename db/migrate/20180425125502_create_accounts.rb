class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'unaccent'
    enable_extension 'uuid-ossp'
    enable_extension 'pgcrypto'

    create_table :accounts do |t|
      t.string :name, null: false, index: true
      t.uuid :uuid, index: true, null: false, default: 'uuid_generate_v4()', unique: true

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
