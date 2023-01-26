class AddUuidToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders , :uuid, :uuid, default: 'gen_random_uuid()', index:  { unique: true }
  end
end
