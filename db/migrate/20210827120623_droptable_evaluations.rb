class DroptableEvaluations < ActiveRecord::Migration[6.1]
  def change
    drop_table :evaluations
  end
end
