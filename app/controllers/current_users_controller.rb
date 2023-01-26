# frozen_string_literal: true

class CurrentUsersController < ::ApiController
  include CheckCurrentPassword
  include PasswordChangeManageTokens
  before_action :validate_current_password, only: :update

  def show
    render_show_json(@current_user, AccountAdmins::Users::ShowSerializer, 'user')
  end

  def update
    if @current_user.update(user_update_params)
      manage_current_tokens
      render_show_json(@current_user, AccountAdmins::Users::ShowSerializer, 'user')
    else
      render_errors_json(@current_user.errors.messages)
    end
  end

  def images
    if @current_user.update(images_params)
      render_show_json(@current_user, AccountAdmins::Users::ShowSerializer, 'user')
    else
      render_errors_json(@current_user.errors.messages)
    end
  end

  private

  def images_params
    params
      .require(:user)
      .permit(:photo,
              :driver_license_photo)
      .transform_values do |value|
      value == 'null' ? nil : value
    end
  end

  def user_update_params
    user_params.merge(updated_by_id: @current_user.id)
  end

  def user_params
    params
      .require(:user)
      .permit(:name,
              :email,
              :birthday,
              :address,
              :phone,
              :cellphone,
              :lunch_time_start,
              :lunch_time_end,
              :work_time_start,
              :work_time_end,
              :driver_license,
              :phone_extension,
              :on_vacation,
              :dont_show_birthday,
              :password,
              :password_confirmation,
              :force_modify_password,
              :shift_id)
  end
end
