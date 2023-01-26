class AddIntegrationToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :integration, foreign_key: true
  end
end
