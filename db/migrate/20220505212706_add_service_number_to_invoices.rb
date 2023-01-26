class AddServiceNumberToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :service_number, :string
  end
end
