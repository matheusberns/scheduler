class AddColumnsToBillings < ActiveRecord::Migration[6.1]
  def change
    add_column :billings, :holder_code, :string
    add_column :billings, :billing_type, :integer
    add_column :billings, :wallet, :string
    add_column :billings, :company_code, :string
  end
end