class ChangeCodTraToPaymentConditions < ActiveRecord::Migration[6.1]
  def change
    rename_column :payment_conditions, :cod_cpg, :code
  end
end
