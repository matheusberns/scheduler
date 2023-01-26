# frozen_string_literal: true

module UserAccess
  extend ActiveSupport::Concern

  included do
    before_action :check_user_access
  end

  private

  def check_user_access
    render_unauthorized_access unless authorized_controller?
  end

  def authorized_controller?
    if @current_user.administrator?
      accessing_administrator_controller?
    elsif @current_user.account_administrator?
      accessing_account_administrator_controller?
    else
      accessing_user_controller?
    end
  end

  def accessing_administrator_controller?
    admin_controller? || region_controller? || enumeration_controller?
  end

  def accessing_account_administrator_controller?
    set_current_user_account
    set_customers
    account_admin_controller? || common_controller?
  end

  def accessing_user_controller?
    set_current_user_account
    set_customers
    user_controller?
  end

  def admin_controller?
    accessed_module == 'admins'
  end

  def account_admin_controller?
    accessed_module == 'account_admins'
  end

  def user_controller?
    not_admin_or_account_admin_controller? || allowed_actions?
  end

  def not_admin_or_account_admin_controller?
    (!admin_controller? && !account_admin_controller?)
  end

  def allowed_actions?
    (%w[account_admins/customers
        account_admins/spaces
        account_admins/spaces/subspaces].include?(accessed_path) &&
      accessed_action == 'autocomplete') ||
      (%w[account_admins/widgets
          account_admins/tools].include?(accessed_path) &&
        accessed_action == 'index')
  end

  def region_controller?
    accessed_module == 'regions'
  end

  def enumeration_controller?
    accessed_module == 'enumerations'
  end

  def common_controller?
    %w[current_users
       homepages
       enumerations
       integrations
       currency_quotations
       regions].include? accessed_module
  end

  def accessed_path
    params[:controller]
  end

  def accessed_action
    params[:action]
  end

  def accessed_module
    params[:controller].split('/').first
  end

  def set_current_user_account
    @account = ::Account.activated.find(@current_user.account_id)
  end

  def set_customers
    @customer_ids = @current_user.customer_ids
  end

  def render_unauthorized_access
    render_error_json nil, 403
  end
end
