class AddRepresentativeToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_reference :customers, :representative, foreign_key: true
  end
end
