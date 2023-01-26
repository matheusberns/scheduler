# frozen_string_literal: true

module Overrides
  class TokenValidationsController < DeviseTokenAuth::TokenValidationsController
    include Renders

    def validate_token
      # @resource will have been set by set_user_by_token concern
      if @resource
        render_show_json(@resource, Overrides::SessionSerializer, 'user')
      else
        render_validate_token_error
      end
    end

    def render_validate_token_error
      render json: { errors: { base: I18n.t('.devise_token_auth.token_validations.invalid') } }, status: 401
    end
  end
end
