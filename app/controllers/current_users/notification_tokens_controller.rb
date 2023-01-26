# frozen_string_literal: true

module CurrentUsers
  class NotificationTokensController < ::ApiController
    before_action :set_notification_token, only: :destroy

    def index
      @notification_tokens = @current_user.notification_tokens

      @notification_tokens = apply_filters(@notification_tokens, :active_boolean)

      render_index_json(@notification_tokens, NotificationTokens::IndexSerializer, 'notification_tokens')
    end

    def create
      @notification_token = @current_user.notification_tokens.new(notification_token_params)

      if @notification_token.save
        render_show_json(@notification_token, NotificationTokens::ShowSerializer, 'notification_token', 201)
      else
        render_errors_json(@notification_token.errors.messages)
      end
    end

    def destroy
      if @notification_token.destroy
        render_success_json
      else
        render_errors_json(@notification_token.errors.messages)
      end
    end

    private

    def set_notification_token
      @notification_token = @current_user
                            .notification_tokens
                            .activated
                            .find_by!(token: params[:token])
    end

    def notification_token_params
      params
        .require(:notification_token)
        .permit(:token,
                :token_type)
        .merge(created_by_id: @current_user.id,
               account_id: @current_user.account_id)
    end
  end
end
