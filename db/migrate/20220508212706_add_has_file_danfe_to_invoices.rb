class AddHasFileDanfeToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :has_file_danfe, :boolean, default: false
  end
end

