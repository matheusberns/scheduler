# frozen_string_literal: true

module Integrations
  class BaseController < ::ApiController
    before_action :is_integrator?

    private

    def is_integrator?
      @current_user.is_integrator
    end
  end
end
