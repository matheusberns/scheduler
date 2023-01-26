# frozen_string_literal: true

module AccountAdmins
  class ToolsController < ::ApiController
    def index
      @account_tools = @account.account_tools.list(@current_user)

      @account_tools = apply_filters(@account_tools, :order_by_tool_name, :by_used_in)

      params[:per_page] = 99

      render_index_json(@account_tools, Tools::IndexSerializer, 'account_tools')
    end

    def autocomplete
      @account_tools = @account.account_tools.autocomplete

      @account_tools = apply_filters(@account_tools, :active_boolean, :by_search)

      render_index_json(@account_tools, Tools::AutocompleteSerializer, 'account_tools')
    end
  end
end
