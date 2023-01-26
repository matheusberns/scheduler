# frozen_string_literal: true

module CheckAuthentication
  extend ActiveSupport::Concern

  included do
    # before_action :check_authentication
  end

  def check_authentication
    request_auth_key = request.headers['authkey'] || params[:authkey]

    incorrect_auth_key = AUTH_KEY != request_auth_key

    render json: {}, status: 403 and return if incorrect_auth_key
  end
end
