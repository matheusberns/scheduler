class CreateEvaluations < ActiveRecord::Migration[6.1]
  def change
    create_table :evaluations do |t|
      t.integer :quality_delivery, index: true, null: true
      t.integer :quality_attendance, index: true, null: true
      t.integer :quality_product, index: true, null: true
      t.integer :quality_average, index: true, null: true
      t.text :quality_delivery_description, null: true
      t.text :quality_attendance_description, null: true
      t.text :quality_product_description, null: true

      t.references :customer, index: true, foreign_key: true
      t.references :order, index: true, foreign_key: true
      t.references :responsible, index: true, foreign_key: {to_table: :users}
      t.references :account, index: true, foreign_key: { to_table: :accounts }

      t.uuid :uuid, index: true, null: false, default: 'uuid_generate_v4()', unique: true
      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.boolean :active, index: true, default: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
