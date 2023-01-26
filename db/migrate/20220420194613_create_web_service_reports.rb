class CreateWebServiceReports < ActiveRecord::Migration[6.1]
  def change
    create_table :web_service_reports do |t|
      t.references :account, index: true, foreign_key: { to_table: :accounts }
      t.references :web_service, index: true, foreign_key: { to_table: :web_services }

      t.string :code, null: false, index: true
      t.string :description, null: false
      t.string :input_variables, null: false
      t.uuid :uuid, default: 'gen_random_uuid()', index: true, unique: true

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
