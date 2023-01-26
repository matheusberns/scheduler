class AddSubtypeToServices < ActiveRecord::Migration[6.1]
  def change
    add_column :services, :service_subtype, :integer
  end
end
