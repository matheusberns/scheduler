# frozen_string_literal: true

module Integrations
  class NotificationsController < BaseController
    before_action :authenticate_user!
    before_action :validate_current_user
    before_action :set_notified_user
    before_action :validate_notified_user

    def create
      @notification = @notified_user.notifications.new(notifications_params)

      if @notification.save
        render json: { success: true }
      else
        render json: { errors: @notification.errors.messages }, status: 422
      end
    end

    private

    def set_notified_user
      notified_cpf = params.dig(:user, :cpf)

      @notified_user = ::User.list.find_by!(cpf: notified_cpf)
    end

    def validate_current_user
      render_invalid_current_user unless valid_current_user?
    end

    def render_invalid_current_user
      render json: { error: 'Usuário logado e token não correspondem' }, status: 401
    end

    def valid_current_user?
      @current_user&.is_integrator && (@current_user&.account_id == @integration.account_id)
    end

    def validate_notified_user
      render_invalid_notified_user unless valid_notified_user?
    end

    def render_invalid_notified_user
      render json: { error: 'Usuário notificado e token não correspondem' }, status: 401
    end

    def valid_notified_user?
      @notified_user.account_id == @integration.account_id
    end

    def notifications_params
      params
        .require(:notification)
        .permit(:title,  :message)
        .merge(account_id: @integration.account_id, notification_type: NotificationTypeEnum::ECOMMERCE,
               notification_origin: NotificationOriginEnum::CENTRAL, notifiable_type: 'Integration', notifiable_id: @integration.id)
    end
  end
end
