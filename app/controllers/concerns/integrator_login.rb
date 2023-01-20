# frozen_string_literal: true

module IntegratorLogin
  extend ActiveSupport::Concern

  def render_unauthorized_error
    render json: { message: 'Acesso não autorizado' }, status: 401
  end

  def invalid_integrator_access?
    @request_token = request.headers[:HTTP_INTEGRATION_TOKEN]

    @integration = ::Integration.list.activated.find_by(token: @request_token)

    @resource&.is_integrator && (invalid_request? || invalid_token?)
  end

  def invalid_request?
    return true if @request_token.nil?

    @integration.remote_ip.split(',').exclude?(request.remote_ip)
  end

  def invalid_token?
    return true if @integration.nil?

    @request_token != @integration.token
  end
end
