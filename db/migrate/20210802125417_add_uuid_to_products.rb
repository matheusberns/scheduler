class AddUuidToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products , :uuid, :uuid, default: 'gen_random_uuid()', index:  { unique: true }
  end
end
