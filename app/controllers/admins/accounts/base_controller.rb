# frozen_string_literal: true

module Admins::Accounts
  class BaseController < ::ApiController
    before_action :set_account

    private

    def set_account
      @account = ::Account.activated.find(params[:account_id]) if params[:account_id]
    end
  end
end
