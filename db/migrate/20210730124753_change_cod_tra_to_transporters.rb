class ChangeCodTraToTransporters < ActiveRecord::Migration[6.1]
  def change
    rename_column :transporters, :cod_tra, :code
  end
end
