# frozen_string_literal: true

module Integrations
  class InstallmentsController < ::ApiController
    def create
      installment_params.each do |installment|
        customer = Customer.find_or_initialize_by({ code: installment['customer']['code'] }) if installment['customer']

        return unless customer

        new_installment = ::Installment.find_or_initialize_by({
                                                                serial_number: installment['serial_number'],
                                                                invoice_number: installment['invoice_number'],
                                                                code: installment['code']
                                                              })

        new_installment.billing_number = installment['billing_number']
        new_installment.billing_type = installment['billing_type']
        new_installment.due_date = installment['expiration']
        new_installment.amount = installment['value']
        new_installment.customer_id = customer.id
        new_installment.created_by_id = @current_user.id
        new_installment.account_id = @current_user.account_id

        new_installment.save!
      end
      render_success_json
    end

    private

    def installment_params
      params.require(:installments)
    end
  end
end
