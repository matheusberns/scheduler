# frozen_string_literal: true

module Homepages::Orders
  class BaseController < ::ApiController
    before_action :set_order

    private

    def set_order
      @order = @current_user.orders.activated.find(params[:order_id]) if params[:order_id]
    end
  end
end
