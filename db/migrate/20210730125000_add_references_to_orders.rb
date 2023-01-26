class AddReferencesToOrders < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :cod_tra
    remove_column :orders, :cod_cpg
    remove_column :orders, :cod_cli

    add_reference :orders, :transporter, index: true, foreign_key: {to_table: :transporters}
    add_reference :orders, :payment_condition, index: true, foreign_key: {to_table: :payment_conditions}
    add_reference :orders, :customer, index: true, foreign_key: {to_table: :customers}
  end
end
