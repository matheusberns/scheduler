# frozen_string_literal: true

module Homepages
  class UsersController < ::ApiController
    skip_before_action :authenticate_user!, only: :by_migration
    skip_before_action :check_user_access, only: :by_migration

    before_action :set_user, only: :info
    before_action :set_chosen_user, only: :by_migration

    def to_talk
      @users = @account.users.activated.list.except_user_to_chat_room(current_user_id: @current_user.id, chat_room_id: params[:chat_room_id])

      @users = apply_filters(@users, :by_search)

      render_index_json(@users, Users::IndexSerializer, 'users')
    end

    def info
      create_access_logs(local_name: 'Informações do usuário')

      render_show_json(@user, Users::ShowSerializer, 'user')
    end

    def user_profile
      create_access_logs(local_name: 'Perfil do usuário')

      @user = @account.users.activated.profile.find_by(id: params[:user_id])

      render_show_json(@user, Users::ProfileSerializer, 'user_profile')
    end

    def by_migration
      @resource = @chosen_user

      @token = @resource.create_token
      @resource.save!

      sign_in(:user, @resource, store: false, bypass: false)

      account_request = ::Accounts::AccountConsult.new(uuid: @resource.account.uuid).find

      render json: {
        user: ActiveModelSerializers::SerializableResource.new(@resource, {
                                                                 serializer: ::Overrides::SessionSerializer,
                                                                 key_transform: (params[:key_transform_camel_lower] ? 'camel_lower' : nil),
                                                                 params: { account_tools: @resource.account_tools.activated.select("#{Many::AccountTool.table_name}.*").select('tools.tool_code').joins(:tool) }
                                                               }).as_json,
        account: account_request[:account]
      }, status: 200
    end

    def validate_solicitation_password
      if @current_user.valid_solicitation_password(user_solicitation_password: solicitation_password_params[:solicitation_password])
        @solicitation = @current_user.solicitations.find(validate_solicitation_password_params[:id])

        @solicitation.confirmation(validate_solicitation_password_params)

        render_show_solicitation_json(@solicitation, 'solicitation')
      else
        render_error_json(status: 422)
      end
    end

    def solicitation_password
      if @current_user.update_column(:solicitation_password, solicitation_password_params[:solicitation_password])
        @solicitation = @current_user.solicitations.find(validate_solicitation_password_params[:id])

        @solicitation.confirmation(validate_solicitation_password_params)

        render_show_solicitation_json(@solicitation, 'solicitation')
      else
        render_error_json(status: 422)
      end
    end

    private

    def set_user
      @user = @account.users.activated.show.find_by(id: params[:user_id])
    end

    def set_chosen_user
      @chosen_user = ::User.activated.show.where(cpf: params[:cpf]).first if params[:cpf].present?
      @chosen_user = ::User.activated.show.where(email: params[:email]).first if @chosen_user.nil? && params[:email].present?

      render_error_json(error: I18n.t('errors.messages.chosen_user_not_found')) if @chosen_user.nil?
    end

    def validate_solicitation_password_params
      params
        .require(:solicitation)
        .permit(:id,
                :latitude,
                :longitude,
                :os,
                :model_device,
                :brand_device,
                :navigator)
        .merge(ip: request.remote_ip,
               platform: request.headers[:HTTP_PLATFORM] || 1)
    end

    def solicitation_password_params
      params
        .require(:user)
        .permit(:solicitation_password)
    end

    def render_show_solicitation_json(object, return_name)
      return_name = return_name.camelize(:lower) if params[:key_transform_camel_lower]

      object_serialized = ActiveModelSerializers::SerializableResource.new(object, {
                                                                             serializer: Homepages::Tools::Solicitations::IndexSerializer,
                                                                             params: { solicitation_password: @current_user.solicitation_password, force_show_file: true },
                                                                             key_transform: (params[:key_transform_camel_lower] ? 'camel_lower' : nil)
                                                                           }).as_json

      render json: { return_name => object_serialized }, status: 200
    end
  end
end
