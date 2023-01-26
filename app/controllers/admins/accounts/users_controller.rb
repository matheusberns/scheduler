# frozen_string_literal: true

module Admins::Accounts
  class UsersController < BaseController
    def index
      @users = @account.users.list.account_administrator

      @users = apply_filters(@users, :active_boolean,
                             :by_name,
                             :by_email)

      render_index_json(@users, Users::IndexSerializer, 'users')
    end
  end
end
