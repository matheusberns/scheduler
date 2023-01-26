class SwitchCityAndStateToCustomers < ActiveRecord::Migration[6.1]
  def change
    remove_column :customers, :city_id_id
    remove_column :customers, :state_id_id

    add_column :customers, :city, :string
    add_column :customers, :state, :string

  end
end
