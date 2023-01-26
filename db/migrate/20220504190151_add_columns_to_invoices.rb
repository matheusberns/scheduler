class AddColumnsToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :cod_emp_erp, :integer
    add_column :invoices, :cod_fil_erp, :integer
    add_column :invoices, :cod_snf_erp, :string
  end
end
