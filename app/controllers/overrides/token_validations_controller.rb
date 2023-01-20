# frozen_string_literal: true

module Overrides
  class TokenValidationsController < DeviseTokenAuth::TokenValidationsController
    include Renders

    def validate_token
      # @resource will have been set by set_user_by_token concern
      if @resource
        @account_tools = @resource.account_tools.activated.select("#{Many::AccountTool.table_name}.*").select('tools.tool_code').joins(:tool)

        unless @resource.integration_tokens.any?
          @resource.integration_tokens << SecureRandom.urlsafe_base64(nil, false)
          @resource.save
        end

        render_show_json(@resource, Overrides::SessionSerializer, 'user', 200, { account_tools: @account_tools })
      else
        render_validate_token_error
      end
    end

    def render_validate_token_error
      render json: { errors: { base: I18n.t('.devise_token_auth.token_validations.invalid') } }, status: 401
    end
  end
end
