class AddInvoiceOrderNumberToBillings < ActiveRecord::Migration[6.1]
  def change
    add_column :billings, :invoice_number, :string
    add_column :billings, :order_number, :string
  end
end
