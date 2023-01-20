# frozen_string_literal: true

module Integrations
  class BaseController < ApplicationController
    before_action :set_integration
    before_action :validate_request_ip

    private

    def set_integration
      request_token = request.headers[:HTTP_INTEGRATION_TOKEN]

      @integration = ::Integration.list.find_by!(token: request_token)
    end

    def validate_request_ip
      render_invalid_request unless valid_request?
    end

    def render_invalid_request
      render_json_message({ error: 'Endereço IP não autorizado' }, 401)
    end

    def valid_request?
      @integration.remote_ip.split(',').include? request.remote_ip
    end
  end
end
