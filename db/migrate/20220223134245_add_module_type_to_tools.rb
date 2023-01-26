class AddModuleTypeToTools < ActiveRecord::Migration[6.1]
  def change
    add_column :tools, :module_type, :integer, null: true
  end
end
