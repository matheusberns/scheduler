# frozen_string_literal: true

module CheckCurrentSolicitationPassword
  extend ActiveSupport::Concern

  included do
    def validate_current_solicitation_password
      return unless  params[:user][:current_solicitation_password].present? && params[:user][:solicitation_password].present?

      object = @user || @current_user

      object.errors.add(:solicitation_password, :uninformed_password) if params[:user].include?(:solicitation_password) && params.dig(:user, :solicitation_password).blank?
      object.errors.add(:current_solicitation_password, :uninformed_current_password) if params[:user].include?(:current_solicitation_password) && params.dig(:user, :current_solicitation_password).blank?
      object.errors.add(:current_solicitation_password, :invalid_current_solicitation_password) if params[:user][:current_solicitation_password] != @current_user.solicitation_password

      render_errors_json(object.errors.messages) if object.errors.any?
    end
  end
end
