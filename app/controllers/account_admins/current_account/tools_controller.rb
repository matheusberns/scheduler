# frozen_string_literal: true

module AccountAdmins::CurrentAccount
  class ToolsController < BaseController
    def index
      @tools = ::Tool.list

      render_index_json(@tools, AccountAdmins::Accounts::Tools::IndexSerializer, 'tools', custom_params)
    end

    private

    def custom_params
      { current_account_id: @account.id }
    end
  end
end
