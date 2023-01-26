class AddUrlFilesToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :danfe_url, :string
    add_column :invoices, :xml_url, :string
  end
end
