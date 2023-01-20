# frozen_string_literal: true

class CurrentUsersController < ::ApiController
  include CheckCurrentSolicitationPassword
  include PasswordChangeManageTokens
  before_action :validate_current_password, only: :change_password
  before_action :validate_current_solicitation_password, only: :update

  def show
    render_show_json(@current_user, AccountAdmins::Users::ShowSerializer, 'user')
  end

  def update
    if @current_user.update(user_update_params)
      render_show_json(@current_user, AccountAdmins::Users::ShowSerializer, 'user')
    else
      render_errors_json(@current_user.errors.messages)
    end
  end

  def change_password
    if @current_user.change_password(change_password_params)
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

  def accept_use_term
    @use_term = @current_user.user_use_terms.find_by(use_term_id: params[:user][:use_term_id])
    if @use_term.update(accept: true)
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
              :driver_license_photo,
              :background_profile_image)
      .transform_values do |value|
      %w[null 0].include?(value) ? nil : value
    end
  end

  def user_update_params
    user_params.merge(updated_by_id: @current_user.id)
  end

  def user_params
    params
      .require(:user)
      .permit(:ethnicity,
              :cellphone,
              :phone,
              :personal_email,
              :zipcode,
              :address,
              :address_number,
              :address_complement,
              :state_id,
              :city_id,
              :district_id,
              :driver_license,
              :driver_license_category,
              :driver_license_expiration_date,
              :phone_extension,
              :dont_show_birthday,
              :solicitation_password,
              :current_solicitation_password)
  end

  def change_password_params
    params
      .require(:user)
      .permit(:current_password,
              :password,
              :password_confirmation)
  end

  def validate_current_password
    valid_params_password?

    unless params.dig(:user, :migration)
      @current_user.errors.add(:current_password, :invalid_current_password) if !@current_user.account.active_directory_can_change_password && !@current_user.valid_password?(params.dig(:user, :current_password))
      @current_user.errors.add(:current_password, :uninformed_current_password) if params.dig(:user, :current_password).blank?
    end

    render_errors_json(@current_user.errors.messages) if @current_user.errors.any?
  end

  def valid_params_password?
    @current_user.errors.add(:password, :required) if !params[:user].include?(:password) || params.dig(:user, :password).blank?
    @current_user.errors.add(:password_confirmation, :required) if !params[:user].include?(:password_confirmation) || params.dig(:user, :password_confirmation).blank?
  end
end
