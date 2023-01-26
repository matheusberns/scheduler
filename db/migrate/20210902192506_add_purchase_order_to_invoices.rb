class AddPurchaseOrderToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :purchase_order, :string
  end
end
