# frozen_string_literal: true

module Overrides
  class SessionsController < DeviseTokenAuth::SessionsController
    include Renders
    include ActiveDirectoryLogin
    include IntegratorLogin
    before_action :login_account, only: [:create]

    def create
      render_login_field_error and return unless login_field.present?

      @resource = if @login_account&.active_directory? && !Rails.env.development?
                    find_active_directory_resource || find_active_devise_resource
                  else
                    find_active_devise_resource
                  end

      render_account_not_found_error and return unless @login_account.present? || @resource&.administrator?

      render_unauthorized_error and return if invalid_integrator_access?

      if valid_devise_resource? || valid_active_directory_resource?
        return render_create_error_bad_credentials if not_login_valid?

        @token = @resource.create_token
        @resource.save

        return render_errors_json(@resource.errors.messages) if @resource.errors.messages.any?

        sign_in(:user, @resource, store: false, bypass: false)

        yield @resource if block_given?

        render_create_success
      elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        if @resource.respond_to?(:locked_at) && @resource.locked_at
          render_create_error_account_locked
        else
          render_create_error_not_confirmed
        end
      else
        render_create_error_bad_credentials
      end
    end

    protected

    def render_create_success
      render_show_json(@resource, SessionSerializer, 'user')
    end

    private

    def not_login_valid?
      valid_password = @resource.valid_password?(resource_params[:password])

      ((@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_password }) || !valid_password) && !@active_directory&.authenticated? && !@active_directory&.persisted?
    end

    def render_account_not_found_error
      render json: { errors: { base: I18n.t('.devise_token_auth.sessions.account_not_found') } }, status: 401
    end

    def render_create_error_bad_credentials
      render json: { errors: { base: @exceeded_attempts ? I18n.t('.devise_token_auth.sessions.bad_credential_exceeded_attempts') : I18n.t('.devise_token_auth.sessions.bad_credentials') } }, status: 401
    end

    def render_create_error_account_locked
      render json: { errors: { base: I18n.t('.devise.mailer.account_lock_msg') } }, status: 401
    end

    def login_account
      request_origin = request&.origin || params[:base_url]
      return if request_origin.nil?

      request_origin = "https://portal.volkdobrasil.com.br" if Rails.env.development?

      @login_account = ::Account.list.find_by(base_url: request_origin)
    end

    def render_login_field_error
      render json: { errors: { base: I18n.t('.devise_token_auth.sessions.login_not_found') } }, status: 401
    end

    def login_field
      permitted_auth_keys = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys)

      old_version_login = permitted_auth_keys.include?(:email)

      @login_field = old_version_login ? :email : :login
    end

    def find_active_devise_resource
      @login_value = get_case_insensitive_field_from_resource_params(@login_field)
      return if @login_value.nil?

      login_with_email = ::Devise.email_regexp.match? @login_value

      if login_with_email
        ::User.active(true).find_by('email' => @login_value)
      else
        only_numbers = @login_value.gsub(/\D/, '')
        return unless only_numbers.present?

        ::User.active(true).find_by('cpf' => only_numbers)

      end
    end

    def valid_devise_resource?
      @resource && valid_params?(@login_field, @login_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
    end
  end
end
