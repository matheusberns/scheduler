# frozen_string_literal: true

module Integrations
  class BillingsController < ::ApiController
    def create
      customer = nil

      billing_params.each do |billing|
        customer = Customer.find_by({ code: billing['customer']['code'] })

        next unless customer

        new_billing = ::Billing.find_or_initialize_by({ billing: billing['billing'] })
        new_billing.customer_id = customer.id
        new_billing.payment_date = billing['payment_date']
        new_billing.emission_date = billing['emission_date']
        new_billing.status = billing['status'].to_i
        new_billing.invoice_number = billing['invoice_number']
        new_billing.order_number = billing['order_number']
        new_billing.due_date = billing['expiration']
        new_billing.billet_file_name = billing['billet_url']
        new_billing.original_amount = billing['original_amount']
        new_billing.amount = billing['amount']
        new_billing.created_by_id = @current_user.id
        new_billing.account_id = @current_user.account_id

        new_billing.save!
      end
      render json: ::Billing.where(customer_id: customer&.id, status: [2, 3]).pluck(:invoice_number).join(',')
    end

    private

    def billing_params
      params.require(:billings)
    end
  end
end
