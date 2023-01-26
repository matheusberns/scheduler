class ChangeStatusToServices < ActiveRecord::Migration[6.1]
  def change
    remove_column :services, :status
    add_column :services, :status, :integer
  end
end
