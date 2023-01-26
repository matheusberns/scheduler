class AddCustomersToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :customer, index: true, foreign_key: true
  end
end
