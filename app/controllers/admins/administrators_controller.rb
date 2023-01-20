# frozen_string_literal: true

module Admins
  class AdministratorsController < ::ApiController
    before_action :validate_current_user
    before_action :set_chosen_user, only: :switch_to_user

    def switch_to_user
      sign_out_administrator

      sign_in_chosen_user

      @account_tools = @resource.account_tools.activated.select("#{Many::AccountTool.table_name}.*").select('tools.tool_code').joins(:tool)

      render_show_json(@resource, Overrides::SessionSerializer, 'user', 200, { account_tools: @account_tools })
    rescue StandardError => e
      render_error_json(error: e)
    end

    private

    def sign_out_administrator
      # remove auth instance variables so that after_action does not run
      user = remove_instance_variable(:@resource) if @resource
      client = @token.client if @token.client
      @token.clear!

      return unless user && client && user.tokens[client]

      user.tokens.delete(client)
      user.save!
    end

    def sign_in_chosen_user
      @resource = @chosen_user

      @token = @resource.create_token
      @integration_token = SecureRandom.urlsafe_base64(nil, false)
      @resource.integration_tokens << @integration_token if @resource.integration_tokens.nil?
      @resource.save!

      sign_in(:user, @resource, store: false, bypass: false)
    end

    def validate_current_user
      render_error_json(error: I18n.t('errors.messages.is_not_administrator')) unless @current_user.administrator?
    end

    def set_chosen_user
      @chosen_user = ::User.activated.find(params[:user_id])

      render_error_json(error: I18n.t('errors.messages.chosen_user_is_administrator')) if @chosen_user.administrator?
    end
  end
end
