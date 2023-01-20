# frozen_string_literal: true

module PasswordChangeManageTokens
  extend ActiveSupport::Concern

  included do
    def manage_current_tokens
      object = @user || @current_user
      current_token = request.headers[:HTTP_CLIENT]
      updating_current_user = object&.id == @current_user&.id

      return unless changing_password? && current_token

      if updating_current_user
        object.keep_current_token current_token
      else
        object.remove_all_tokens
      end
    end
  end

  def changing_password?
    params.dig(:user, :password) && params.dig(:user, :password_confirmation)
  end
end
