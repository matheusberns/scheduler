# frozen_string_literal: true

module Homepages::Customers
  class BaseController < ::ApiController
    before_action :set_customer

    private

    def set_customer
      @customer = @current_user.account.customers.activated.find(params[:customer_id]) if params[:customer_id]
    end
  end
end
