module Overrides
  class PasswordsController < DeviseTokenAuth::PasswordsController
    include Renders

    # this action is responsible for generating password reset tokens and sending emails
    def create
      return render_create_error_missing_email unless resource_params[:email]

      @email = get_case_insensitive_field_from_resource_params(:email)
      @resource = resource_class.dta_find_by(email: @email)

      set_default_url_to_email

      if @resource
        yield @resource if block_given?
        if @resource.account.try(:smtp_email)
          @client_config = params[:config_name] ||= 'default'

          @resource.send_reset_password_instructions(
            email: @email,
            provider: 'email',
            redirect_url: @redirect_url,
            authkey: AUTH_KEY,
            client_config: params[:config_name]
          )

          if @resource.errors.empty?
            render_success_json
          else
            render_create_error @resource.errors
          end

        else
          render_config_not_found
        end
      else
        render_not_found_error
      end
    end

    def edit
      # if a user is not found, return nil
      @resource = resource_class.with_reset_password_token(resource_params[:reset_password_token])

      if @resource&.reset_password_period_valid?
        token = @resource.create_token unless require_client_password_reset_token?

        # ensure that user is confirmed
        @resource.skip_confirmation! if confirmable_enabled? && !@resource.confirmed_at
        # allow user to change password once without current_password
        @resource.allow_password_change = true if recoverable_enabled?

        @resource.save!

        yield @resource if block_given?

        if require_client_password_reset_token?
          redirect_to DeviseTokenAuth::Url.generate(@redirect_url, reset_password_token: resource_params[:reset_password_token])
        else
          redirect_header_options = { reset_password: true }
          redirect_headers = build_redirect_headers(token.token,
                                                    token.client,
                                                    redirect_header_options)
          redirect_to(@resource.build_auth_url(@redirect_url,
                                               redirect_headers))
        end
      else
        render_edit_error
      end
    end

    def update
      # make sure user is authorized
      if require_client_password_reset_token? && resource_params[:reset_password_token]
        @resource = resource_class.with_reset_password_token(resource_params[:reset_password_token])
        return render_update_error_unauthorized unless @resource

        @token = @resource.create_token
      else
        @resource = set_user_by_token
      end

      return render_update_error_unauthorized unless @resource

      # ensure that password params were sent
      return render_update_error_missing_password unless password_resource_params[:password] && password_resource_params[:password_confirmation]

      if @resource.send(resource_update_method, password_resource_params)
        @resource.allow_password_change = false if recoverable_enabled?
        @resource.save!

        yield @resource if block_given?
        render_update_success
      else
        render_update_error
      end
    end

    def render_create_error_missing_email
      render json: { errors: { base: I18n.t('.devise_token_auth.passwords.missing_email') } }, status: 401
    end

    def render_not_found_error
      render json: { errors: { base: I18n.t('.devise_token_auth.passwords.user_not_found', email: resource_params[:email]) } }, status: 401
    end

    def render_edit_error
      render json: { errors: { base: I18n.t('.devise_token_auth.passwords.reset_password_token') } }, status: 401
    end

    def render_create_error(errors)
      errors = errors.dup.deep_transform_keys! { |key| key.to_s.camelize(:lower) } if params[:key_transform_camel_lower]
      object_errors = {}
      errors.each do |field, field_errors|
        object_errors[field] = field_errors.first
      end
      render json: { errors: object_errors }, status: :unprocessable_entity
    end

    private

    def set_default_url_to_email
      ActionMailer::Base.default_url_options[:host] = request.base_url
    end
  end
end
