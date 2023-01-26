class AddHasFileBilletToBillings < ActiveRecord::Migration[6.1]
  def change
    add_column :billings, :has_file_billet, :boolean, default: false
  end
end
