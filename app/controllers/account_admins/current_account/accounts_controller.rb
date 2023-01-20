# frozen_string_literal: true

module AccountAdmins::CurrentAccount
  class AccountsController < BaseController
    def show
      render_show_json(@account, AccountAdmins::Accounts::ShowSerializer, 'current_account')
    end

    def update
      if @account.update(account_update_params)
        render_show_json(@account, AccountAdmins::Accounts::ShowSerializer, 'current_account')
      else
        render_errors_json(@account.errors.messages)
      end
    end

    def images
      if @account.update(images_params)
        render_show_json(@account, AccountAdmins::Accounts::ShowSerializer, 'current_account')
      else
        render_errors_json(@account.errors.messages)
      end
    end

    private

    def account_update_params
      account_params.merge(updated_by_id: @current_user.id)
    end

    def images_params
      params.require(:account).permit(:logo,
                                      :menu_background,
                                      :toolbar_background)
            .transform_values do |value|
        value == 'null' ? nil : value
      end
    end

    def account_params
      params.require(:account).permit(:users_timeout,
                                      :mandatory_comment,
                                      :timeout_in,
                                      :layout_space_bar)
    end
  end
end
