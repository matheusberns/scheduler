# frozen_string_literal: true

module Homepages
  class PaymentConditionsController < ::ApiController
    before_action :set_payment_condition, only: %i[show]

    def index
      @payment_conditions = @current_user.account.payment_conditions.list

      @payment_conditions = apply_filters(@payment_conditions, :by_homepage_search)

      render_index_json(@payment_conditions, PaymentConditions::IndexSerializer, 'payment_conditions')
    end

    def show
      render_show_json(@payment_condition, PaymentConditions::ShowSerializer, 'payment_condition', 200)
    end

    private

    def set_payment_condition
      @payment_condition = @current_user.account.payment_conditions.show.find(params[:id])
    end
  end
end
