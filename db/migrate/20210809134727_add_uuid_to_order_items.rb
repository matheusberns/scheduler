class AddUuidToOrderItems < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items , :uuid, :uuid, default: 'gen_random_uuid()', index:  { unique: true }
  end
end
