class AddFieldFileNameToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :xls_file_name, :string
    add_column :orders, :pdf_file_name, :string
  end
end
