# frozen_string_literal: true

module Admins
  class AccountsController < ::ApiController
    before_action :set_account, only: %i[show update destroy images]

    def index
      @accounts = ::Account.list

      @accounts = apply_filters(@accounts, :active_boolean,
                                :by_name,
                                :by_uuid)

      render_index_json(@accounts, ::Admins::Accounts::IndexSerializer, 'accounts')
    end

    def autocomplete
      @accounts = ::Account.autocomplete

      @accounts = apply_filters(@accounts, :active_boolean, :by_search)

      render_index_json(@accounts, ::Admins::Accounts::AutocompleteSerializer, 'accounts')
    end

    def show
      render_show_json(@account, ::Admins::Accounts::ShowSerializer, 'account')
    end

    def create
      @account = ::Account.new(account_create_params)

      if @account.save
        render_show_json(@account, ::Admins::Accounts::ShowSerializer, 'account', 201)
      else
        render_errors_json(@account.errors.messages)
      end
    end

    def update
      if @account.update(account_update_params)
        render_show_json(@account, ::Admins::Accounts::ShowSerializer, 'account')
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
        render_show_json(@account, ::Admins::Accounts::ShowSerializer, 'account')
      else
        render_errors_json(@account.errors.messages)
      end
    end

    def images
      if @account.update(images_params)
        render_show_json(@account, ::Admins::Accounts::ShowSerializer, 'account')
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
          :timeout_in,
          :reports_sender_email,
          :is_active_directory,
          :active_directory_host,
          :active_directory_base,
          :active_directory_domain,
          primary_color: {},
          secondary_color: {},
          primary_colors: %i[name color contrast_color],
          secondary_colors: %i[name color contrast_color]
        )
    end
  end
end
