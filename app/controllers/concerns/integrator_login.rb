# frozen_string_literal: true

module IntegratorLogin
  extend ActiveSupport::Concern

  def render_unauthorized_error
    render json: { message: 'Acesso não autorizado' }, status: 401
  end

  def invalid_integrator_access?
    @request_token = request.headers[:authkey]
    @integration = ::Integration.list.activated.find_by(token: @request_token)

    invalid_token?
  end

  def invalid_token?
    return true if @integration.nil?

    @request_token != @integration.token
  end
end
