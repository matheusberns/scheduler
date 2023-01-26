class ChangeColumnNameToBillingds < ActiveRecord::Migration[6.1]
  def change
    rename_column :billings, :security, :billing
  end
end
