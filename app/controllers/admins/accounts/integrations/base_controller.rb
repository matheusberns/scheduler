# frozen_string_literal: true

module Admins::Accounts::Integrations
  class BaseController < ::ApiController
    before_action :set_integration

    private

    def set_integration
      @integration = ::Integration.activated.find(params[:integration_id]) if params[:integration_id]
    end
  end
end
