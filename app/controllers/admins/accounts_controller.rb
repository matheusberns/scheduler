# frozen_string_literal: true

module Admins
  class AccountsController < ::ApiController
    before_action :set_account, only: %i[show update destroy images send_mail]

    def index
      @accounts = ::Account.list

      @accounts = apply_filters(@accounts, :active_boolean,
                                :by_name,
                                :by_uuid)

      render_index_json(@accounts, Accounts::IndexSerializer, 'accounts')
    end

    def autocomplete
      @accounts = ::Account.autocomplete

      @accounts = apply_filters(@accounts, :active_boolean, :by_search)

      render_index_json(@accounts, Accounts::AutocompleteSerializer, 'accounts')
    end

    def show
      render_show_json(@account, Accounts::ShowSerializer, 'account')
    end

    def create
      @account = ::Account.new(account_create_params)

      if @account.save
        render_show_json(@account, Accounts::ShowSerializer, 'account', 201)
      else
        render_errors_json(@account.errors.messages)
      end
    end

    def update
      if @account.update(account_update_params)
        render_show_json(@account, Accounts::ShowSerializer, 'account')
      else
        render_errors_json(@account.errors.messages)
      end
    end

    def destroy
      if @account.destroy
        render_success_json
      else
        render_errors_json(@account.errors.messages)
      end
    end

    def recover
      @account = ::Account.list.active(false).find(params[:id])

      if @account.recover
        render_show_json(@account, Accounts::ShowSerializer, 'account')
      else
        render_errors_json(@account.errors.messages)
      end
    end

    def images
      if @account.update(images_params)
        render_show_json(@account, Accounts::ShowSerializer, 'account')
      else
        render_errors_json(@account.errors.messages)
      end
    end

    def send_mail
      if @account.send_mail(received_email: params[:received_email])
        render_success_json
      else
        render_errors_json(@account.errors.messages)
      end
    end

    private

    def set_account
      @account = ::Account.activated.list.find(params[:id])
    end

    def account_create_params
      account_params.merge(created_by_id: @current_user.id)
    end

    def account_update_params
      account_params.merge(updated_by_id: @current_user.id)
    end

    def images_params
      params
        .require(:account)
        .permit(:logo,
                :menu_background,
                :toolbar_background)
        .transform_values do |value|
        value == 'null' ? nil : value
      end
    end

    def account_params
      params
        .require(:account)
        .permit(
          :uuid,
          :smtp_user,
          :smtp_password,
          :smtp_host,
          :smtp_host,
          :smtp_email,
          :smtp_ssl,
          :users_timeout,
          :mandatory_comment,
          :timeout_in,
          :timeout_in_to_all_users,
          :imap_host,
          :imap_port,
          :imap_user,
          :imap_password,
          :imap_ssl,
          :imap_execution_max_time,
          :imap_execution_interval_time,
          :reports_sender_email,
          :is_active_directory,
          :active_directory_host,
          :active_directory_base,
          :active_directory_domain,
          :active_directory_cpf_field,
          :active_directory_can_change_password,
          :active_directory_ca_file,
          :active_directory_ssl_version,
          :active_directory_password_recover_url,
          :active_directory_password_change_url,
          :active_directory_password_change_guide,
          :layout_space_bar,
          :user_can_reset_pin,
          :blocked_chat,
          :blocked_chat_message,
          :logout_by_tab_closed,
          :logout_by_tab_closed_to_all_users
        )
    end
  end
end
