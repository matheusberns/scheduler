# frozen_string_literal: true

module Admins::Accounts
  class ToolsController < BaseController
    before_action :set_tool, only: %i[show]
    before_action :set_account_tool, only: %i[update]

    def index
      @tools = ::Tool.list

      @tools = apply_filters(@tools, :active_boolean,
                             :by_name,
                             :by_module_type)

      render_index_json(@tools,
                        ::AccountAdmins::Accounts::Tools::IndexSerializer,
                        'tools',
                        custom_params)
    end

    def create
      @account_tool = @account.all_account_tools.find_or_initialize_by(account_tool_create_params)
      @account_tool.created_by_id = @current_user.id

      if @account_tool.save
        @account_tool.recover if @account_tool.deleted?

        render_success_json(status: 201)
      else
        render_errors_json(@account_tool.errors.messages)
      end
    end

    def show
      render_show_json(@tool, ::AccountAdmins::Accounts::Tools::ShowSerializer, 'tool', 200, custom_params)
    end

    def update
      if @account_tool.update(account_tool_update_params)
        render_success_json
      else
        render_errors_json(@account_tool.errors.messages)
      end
    end

    def destroy
      if @account.account_tools.where(tool_id: params[:id]).destroy_all
        render_success_json
      else
        render_errors_json(@account_tool.errors.messages)
      end
    end

    def enable_all
      tools_ids.each do |tool_id|
        @account_tool = @account.all_account_tools.find_or_initialize_by(tool_id: tool_id)
        @account_tool.created_by_id = @current_user.id
        @account_tool.active = true
        @account_tool.deleted_at = nil

        next unless @account_tool.save

        @account.call(tool_id: @account_tool.tool_id)
      end

      render_success_json(status: 201)
    end

    def disable_all
      @account.all_account_tools.where(tool_id: tools_ids).destroy_all

      tools_ids.each do |tool_id|
        @account.call(tool_id: tool_id, active: false)
      end

      render_success_json
    rescue StandardError
      render_error_json(error: I18n.t('errors.messages.unprocessable_entity'))
    end

    private

    def custom_params
      { current_account_id: @account.id }
    end

    def set_tool
      @tool = ::Tool.list.find(params[:id])
    end

    def set_account_tool
      @account_tool = @account.account_tools.activated.find_by!(tool_id: params[:id])
    end

    def account_tool_update_params
      params
        .require(:account_tool)
        .permit(:ecommerce_url,
                :required_confirmation,
                :required_solicitation_password,
                :generate_automatic_file)
        .merge(updated_by_id: @current_user.id)
    end

    def tools_ids
      params.dig(:account_tool, :tools_ids) || []
    end

    def account_tool_create_params
      params
        .require(:account_tool)
        .permit(:tool_id)
    end
  end
end
