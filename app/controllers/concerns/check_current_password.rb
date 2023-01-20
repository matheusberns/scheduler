# frozen_string_literal: true

module CheckCurrentPassword
  extend ActiveSupport::Concern

  included do
    def validate_current_password
      object = @user || @current_user

      valid_params_password?(object)

      if !params.dig(:user, :migration) && params[:user].include?(:current_password)
        object.errors.add(:current_password, :invalid_current_password) unless object.valid_password? params.dig(:user, :current_password)
        object.errors.add(:current_password, :uninformed_current_password) if params.dig(:user, :current_password).blank?
      end

      render_errors_json(object.errors.messages) if object.errors.any?
    end
  end

  def valid_params_password?(object)
    object.errors.add(:password, :required) if params[:user].include?(:password) && params.dig(:user, :password).blank?
    object.errors.add(:password_confirmation, :required) if params[:user].include?(:password_confirmation) && params.dig(:user, :password_confirmation).blank?
  end
end
