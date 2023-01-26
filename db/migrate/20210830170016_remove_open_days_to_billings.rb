class RemoveOpenDaysToBillings < ActiveRecord::Migration[6.1]
  def change
    remove_column :billings, :open_days
  end
end
