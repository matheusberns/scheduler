class AddPriorityTypeToServices < ActiveRecord::Migration[6.1]
  def change
    add_column :services, :priority_type, :integer
  end
end
