# frozen_string_literal: true

module CheckCurrentPassword
  extend ActiveSupport::Concern

  included do
    def validate_current_password
      return unless changing_password?

      object = @user || @current_user

      return if object.valid_password? params.dig(:user, :current_password)

      object.errors.add(:current_password, :invalid_current_password)
      render_errors_json(object.errors.messages)
    end
  end

  def changing_password?
    params.dig(:user, :password) && params.dig(:user, :password_confirmation)
  end
end
