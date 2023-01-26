class CreateWebServices < ActiveRecord::Migration[6.1]
  def change
    create_table :web_services do |t|
      t.references :account, index: true, foreign_key: { to_table: :accounts }

      t.string :url_base, null: true
      t.string :wsdl, null: true
      t.string :user, null: true
      t.string :password, null: true
      t.integer :web_service_type, null: false

      t.uuid :uuid, default: 'gen_random_uuid()', index: true, unique: true

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
