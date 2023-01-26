# frozen_string_literal: true

module Admins::Accounts
  class CustomersController < BaseController
    def index
      @customers = @account.customers.list

      @customers = apply_filters(@customers, :active_boolean,
                                 :by_name,
                                 :by_email)

      render_index_json(@customers, Customers::IndexSerializer, 'customers')
    end
  end
end
