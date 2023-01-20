# frozen_string_literal: true

module Admins::Accounts
  class HeadquartersController < BaseController
    before_action :set_headquarter, only: %i[update show]

    def index
      @headquarters = @account.headquarters.list

      @headquarters = apply_filters(@headquarters, :active_boolean,
                                    :by_name,
                                    :by_nickname,
                                    :by_social_reason,
                                    :by_cnpj)

      render_index_json(@headquarters, Headquarters::IndexSerializer, 'headquarters')
    end

    def show
      render_show_json(@headquarter, Headquarters::ShowSerializer, 'headquarter')
    end

    def update
      if @headquarter.update(headquarter_update_params)
        render_show_json(@headquarter, Headquarters::ShowSerializer, 'headquarter')
      else
        render_errors_json(@headquarter.errors.messages)
      end
    end

    private

    def set_headquarter
      @headquarter = @account.headquarters.activated.list.find(params[:id])
    end

    def headquarter_update_params
      headquarter_params.merge(updated_by_id: @current_user.id)
    end

    def headquarter_params
      params
        .require(:headquarter)
        .permit(:cod_emp_erp,
                :cod_fil_erp,
                :primary_color,
                :secondary_color,
                primary_color: {},
                secondary_color: {},
                primary_colors: %i[name color contrast_color],
                secondary_colors: %i[name color contrast_color])
    end
  end
end
