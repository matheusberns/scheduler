class AddUuidToTransporters < ActiveRecord::Migration[6.1]
  def change
    add_column :transporters , :uuid, :uuid, default: 'gen_random_uuid()', index:  { unique: true }
  end
end
