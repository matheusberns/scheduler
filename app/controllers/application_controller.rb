# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Devise concerns
  include DeviseTokenAuth::Concerns::SetUserByToken

  # Velow concerns
  include CheckAuthentication

  def default_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
  end
end
