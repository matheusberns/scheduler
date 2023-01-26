class RemoveOrderReferenceToBudgets < ActiveRecord::Migration[6.1]
  def change
    remove_reference :budgets, :order
    add_reference :orders, :budget, index: true, foreign_key: true
  end
end
