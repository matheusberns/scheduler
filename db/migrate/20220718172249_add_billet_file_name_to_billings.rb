class AddBilletFileNameToBillings < ActiveRecord::Migration[6.1]
  def change
    add_column :billings, :billet_file_name, :string
  end
end
