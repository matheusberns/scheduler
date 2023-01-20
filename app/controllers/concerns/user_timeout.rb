# frozen_string_literal: true

module UserTimeout
  extend ActiveSupport::Concern

  included do
    before_action :user_timeout
  end

  def user_timeout
    return unless @current_user&.users_timeout

    @current_user.tokens[@token.client]['expiry'] = (Time.now + @current_user.timeout_in.to_i.minutes).to_i

    @current_user.save
  end
end
