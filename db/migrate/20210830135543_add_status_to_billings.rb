class AddStatusToBillings < ActiveRecord::Migration[6.1]
  def change
    add_column :billings, :status, :integer
    add_column :billings, :emission_date, :datetime
    add_column :billings, :payment_date, :datetime
  end
end
