# frozen_string_literal: true

module Admins::Accounts::Integrations
  class UsersController < BaseController
    before_action :set_user, only: %i[show update destroy]

    def index
      @users = @integration.users

      @users = apply_filters(@users, :active_boolean)

      render_index_json(@users, Users::IndexSerializer, 'users')
    end

    def show
      render_show_json(@user, Users::ShowSerializer, 'user')
    end

    def create
      @user = @integration.users.new(user_create_params)

      if @user.save
        render_show_json(@user, Users::ShowSerializer, 'user', 201)
      else
        render_errors_json(@user.errors.messages)
      end
    end

    def update
      if @user.update(user_update_params)
        render_show_json(@user, Users::ShowSerializer, 'user')
      else
        render_errors_json(@user.errors.messages)
      end
    end

    def destroy
      if @user.destroy
        render_success_json
      else
        render_errors_json(@user.errors.messages)
      end
    end

    def recover
      @user = @integration.users.active(false).find(params[:id])

      if @user.recover
        render_show_json(@user, Users::ShowSerializer, 'user')
      else
        render_errors_json(@user.errors.messages)
      end
    end

    private

    def set_user
      @user = @integration.users.activated.find(params[:id])
    end

    def user_create_params
      user_params.merge(created_by_id: @current_user&.id, is_integrator: true)
    end

    def user_update_params
      user_params.merge(updated_by_id: @current_user&.id)
    end

    def user_params
      params
        .require(:user)
        .permit(:name,
                :email,
                :password,
                :password_confirmation)
    end
  end
end
