# frozen_string_literal: true

class ApiController < ApplicationController
  include ActionController::MimeResponds

  before_action :authenticate_user!

  # concerns
  include ApplyFilters
  include Renders
  include Sortable
  include UserAccess
  include UserTimeout

  def find_permission(permission_codes)
    codes = @current_user.permissions.pluck(:code)

    @current_user.is_account_admin || permission_codes.filter { |code| codes.include?(code) }.any?
  end

  def manager_permission
    @current_user.managers_team.any?
  end

  def create_access_logs(local_name:)
    @current_user.access_logs.create(
      {
        account_id: @current_user.account_id,
        created_by_id: @current_user.id,
        local_name: local_name,
        platform: request.headers[:HTTP_PLATFORM] || 1
      }
    )
  end
end
