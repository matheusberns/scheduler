class ChangeSecuritiesTableName < ActiveRecord::Migration[6.1]
  def change
    rename_table :securities, :billings
  end
end
