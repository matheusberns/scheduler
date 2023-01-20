# frozen_string_literal: true

module Admins::Accounts
  class UsersController < BaseController
    def index
      @users = @account.users.list

      @users = apply_filters(@users, :active_boolean,
                             :by_name,
                             :by_identification_number,
                             :by_email)

      render_index_json(@users, Users::IndexSerializer, 'users')
    end

    def import
      @import_csv = ::Import::UserCsv.new(@account, params[:file])

      if @import_csv.import
        render_success_json
      else
        render_error_json(error: @import_csv.errors)
      end
    end
  end
end
