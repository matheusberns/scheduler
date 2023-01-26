class ChangeDataTypeToEmissionDateInvoices < ActiveRecord::Migration[6.1]
  def change
    change_column :invoices, :emission_date, :datetime
  end
end
