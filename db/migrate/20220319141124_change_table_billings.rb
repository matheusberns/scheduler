class ChangeTableBillings < ActiveRecord::Migration[6.1]
  def change
    rename_column :billings, :expiration, :due_date
    rename_column :billings, :value, :amount

    add_column :billings, :original_due_date, :datetime
    add_column :billings, :observation, :text
    add_column :billings, :original_amount, :float
  end
end
