class ChangeTableInstallments < ActiveRecord::Migration[6.1]
  def change
    rename_column :installments, :expiration, :due_date
    rename_column :installments, :value, :amount
  end
end
