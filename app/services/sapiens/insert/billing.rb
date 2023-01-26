# frozen_string_literal: true

module Sapiens
  module Insert
    class Billing < ::Sapiens::Base
      def connection(params, customer)
        params.each do |param|
          new_billing = customer.billings.find_or_initialize_by({ billing: param['billing'] })

          new_billing.emission_date = param['emission_date']
          case param['status']
          when 'AB'
            status = 1
          when 'CA'
            status = 4
          when 'LQ'
            status = 3
          end

          new_billing.payment_date = param['payment_date'].to_date.strftime('%Y-%m-%d') == '1900-12-31' ? nil :  param['payment_date']
          new_billing.status = status
          new_billing.invoice_number = param['invoice_number']
          new_billing.order_number = param['order_number']
          new_billing.original_due_date = param['original_due_date'].to_time.middle_of_day
          new_billing.due_date = param['due_date'].to_time.middle_of_day
          new_billing.observation = param['observation']
          new_billing.original_amount = param['original_amount']
          new_billing.amount = param['amount']
          new_billing.account_id = customer.account_id
          new_billing.holder_code = param['holder_code']
          new_billing.billing_type = param['billing_type']
          new_billing.wallet = param['wallet']
          new_billing.company_code = param['company_code']
          new_billing.save
        end
      rescue StandardError => e
        { service: { message: e.message } }
      end
    end
  end
end
