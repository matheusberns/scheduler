class AddUuidToPaymentConditions < ActiveRecord::Migration[6.1]
  def change
    add_column :payment_conditions , :uuid, :uuid, default: 'gen_random_uuid()', index:  { unique: true }
  end
end
