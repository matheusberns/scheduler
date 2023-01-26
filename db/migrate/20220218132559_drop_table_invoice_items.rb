class DropTableInvoiceItems < ActiveRecord::Migration[6.1]
  def change
    drop_table :invoice_items
  end
end
