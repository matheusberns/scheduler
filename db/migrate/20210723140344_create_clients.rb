class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :cod_cli, null: false
      t.string :uuid
      t.string :cnpj, null: false
      t.string :nickname
      t.string :zipcode
      t.string :address
      t.string :address_number
      t.string :email
      t.string :phone
      t.string :secondary_phone
      t.string :address_complement
      t.string :social_reason

      t.references :account, index: true, foreign_key: { to_table: :accounts }
      t.references :state_id, index: true, foreign_key: { to_table: :states }
      t.references :city_id, index: true, foreign_key: { to_table: :cities }

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
