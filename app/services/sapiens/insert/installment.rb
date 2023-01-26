# frozen_string_literal: true

module Sapiens
  module Insert
    class Installment < ::Sapiens::Base
      def connection(params, invoice)
        params.each do |param|
          new_installment = invoice.installments.find_or_initialize_by(
            {
              serial_number: param['serial_number'],
              billing_number: param['billing_number'],
              code: param['code']
            }
          )

          new_installment.billing_number = param['billing_number']
          new_installment.billing_type = param['billing_type']
          new_installment.due_date = param['due_date'].to_time.middle_of_day
          new_installment.amount = param['amount']
          new_installment.invoice_number = invoice.invoice_number
          new_installment.customer_id = invoice.customer_id
          new_installment.account_id = invoice.account_id
          new_installment.save
        end
      rescue StandardError => e
        { service: { message: e.message } }
      end
    end
  end
end
