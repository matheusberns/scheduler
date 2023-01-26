# frozen_string_literal: true

module Integrations
  class UsersController < ::ApiController
    before_action :set_user, only: :destroy

    def destroy
      if @user.destroy
        render_success_json
      else
        render_error_json "Não foi possível remover o acesso do usuário: #{@user.email}"
      end
    end

    private

    def user_params
      params.require(:user)
    end

    def set_user
      @user = ::User.find_by(email: params[:user][:email])
    end

  end
end
