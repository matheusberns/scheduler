class ChangeBillingTypeToBillings < ActiveRecord::Migration[6.1]
  def change
    change_column :billings, :billing_type, :string, null: true
end
end
