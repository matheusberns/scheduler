class AddRemoteIpToIntegrations < ActiveRecord::Migration[6.1]
  def change
    add_column :integrations, :remote_ip, :string
  end
end
