class AddStatusToBudgets < ActiveRecord::Migration[6.1]
  def change
    add_column :budgets, :status, :integer, default: 1
  end
end
