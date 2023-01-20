# frozen_string_literal: true

module AccountAdmins::CurrentAccount
  class BaseController < ::ApiController
    before_action :set_account, :validate_permission

    private

    def set_account
      @account = @current_user.account
    end

    def validate_permission
      render_error_json(status: 405) unless find_permission([::PermissionCodeEnum::ACCOUNT_MANAGE])
    end
  end
end
