# frozen_string_literal: true

module ControllerSpecHelper
  def self.included(base)
    access_controller = base.controller_class.to_s.split('::').first

    case access_controller
    when 'AccountAdmins'
      base.before(:each) { set_current_user :account_admin }
    when 'Admins'
      base.before(:each) { set_current_user :admin }
    else
      base.before(:each) { set_current_user :common }
    end

    base.before { request.headers.merge!(@current_user.create_new_auth_token) }
    base.before { request.headers.merge!({ HTTP_AUTHKEY: AUTH_KEY }) }
  end

  private

  def set_current_user(user_type)
    set_account

    current_user_params = ::FactoryBot
                          .attributes_for(:user, user_type.to_sym)
    current_user_params.merge(account_id: @account.id) if user_type != :admin

    @current_user = ::User.create!(current_user_params)
  end

  def set_account
    @account = ::FactoryBot.create(:account)
  end
end
