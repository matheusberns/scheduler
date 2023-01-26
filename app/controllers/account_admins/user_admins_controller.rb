# frozen_string_literal: true

module AccountAdmins
  class UserAdminsController < ::ApiController
    include CheckCurrentPassword
    include PasswordChangeManageTokens
    before_action :validate_current_password, only: :update
    before_action :set_user, only: %i[show update destroy images]

    def index
      @users = @account.users.list.where(customer_id: nil).account_administrator

      @users = apply_filters(@users, :active_boolean,
                             :by_name,
                             :by_email,
                             :by_phone_extension,
                             :by_license_plate,
                             :by_birthday_date_range)

      render_index_json(@users, Users::IndexSerializer, 'users')
    end

    def autocomplete
      @users = @account.users.autocomplete

      @users = apply_filters(@users, :active_boolean, :by_search)

      render_index_json(@users, Users::AutocompleteSerializer, 'users')
    end

    def show
      render_show_json(@user, Users::ShowSerializer, 'user')
    end

    def create
      @user = @account.users.new(user_create_params.merge(is_account_admin: true))

      if @user.save
        render_show_json(@user, Users::ShowSerializer, 'user', 201)
      else
        render_errors_json(@user.errors.messages)
      end
    end

    def update
      if @user.update(user_update_params)
        manage_current_tokens
        render_show_json(@user, Users::ShowSerializer, 'user', 200)
      else
        render_errors_json(@user.errors.messages)
      end
    end

    def destroy
      verify_if_is_current_user_being_destroyed
      if @user.destroy
        render_success_json
      else
        render_errors_json(@user.errors.messages)
      end
    end

    def recover
      @user = @account.users.list.active(false).find(params[:id])

      if @user.recover
        render_show_json(@user, Users::ShowSerializer, 'user')
      else
        render_errors_json(@user.errors.messages)
      end
    end

    def images
      if @user.update(images_params)
        render_show_json(@user, Users::ShowSerializer, 'user')
      else
        render_errors_json(@user.errors.messages)
      end
    end

    private

    def verify_if_is_current_user_being_destroyed
      @user.errors.add(:base, :current_user_being_destroyed) if @current_user.id == @user.id
    end

    def set_user
      @user = @account.users.activated.list.find(params[:id])
    end

    def user_create_params
      user_params.merge(created_by_id: @current_user.id)
    end

    def user_update_params
      user_params.merge(updated_by_id: @current_user.id)
    end

    def images_params
      params
        .require(:user)
        .permit(:photo,
                :driver_license_photo)
        .transform_values do |value|
        value == 'null' ? nil : value
      end
    end

    def user_params
      params
        .require(:user)
        .permit(:name,
                :email,
                :cpf,
                :birthday,
                :address,
                :admission_date,
                :phone,
                :cellphone,
                :driver_license,
                :phone_extension,
                :on_vacation,
                :dont_show_birthday,
                :is_account_admin,
                :password,
                :password_confirmation,
                :force_modify_password)
    end
  end
end
