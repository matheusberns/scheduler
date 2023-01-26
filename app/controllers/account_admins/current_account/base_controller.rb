# frozen_string_literal: true

module AccountAdmins::CurrentAccount
  class BaseController < ::ApiController
    before_action :set_account

    private

    def set_account
      @account = @current_user.account
    end
  end
end
