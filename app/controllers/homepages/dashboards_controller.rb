# frozen_string_literal: true

module Homepages
  class DashboardsController < ::ApiController
    def get_annual_orders
      @dashboards = ::Dashboard.get_annual_orders(current_user: @current_user)

      render json: { dashboard: @dashboards }
    end

    def get_billings_by_status
      @dashboards = ::Dashboard.get_billings_by_status(current_user: @current_user)

      render json: { dashboard: @dashboards }
    end

    def get_open_billings
      @dashboards = ::Dashboard.get_open_billings(current_user: @current_user)

      render json: { dashboard: @dashboards }
    end
  end
end
