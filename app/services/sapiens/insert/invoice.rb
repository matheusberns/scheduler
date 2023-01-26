# frozen_string_literal: true

module Sapiens
  module Insert
    class Invoice < ::Sapiens::Base
      def connection(params, customer)
        params.each do |param|
          new_invoice = customer.invoices.find_or_initialize_by(
            {
              invoice_number: param['invoice_number'],
              cod_emp_erp: param['codemp'],
              cod_fil_erp: param['codfil'],
              cod_snf_erp: param['codsnf']
            }
          )

          new_invoice.total_value = param['total_value']
          new_invoice.service_number = param['numnfs'].to_i
          new_invoice.emission_date = param['emission_date'].to_time
          new_invoice.invoice_type = param['invoice_type']
          new_invoice.status = param['status']
          new_invoice.cod_emp_erp = param['codemp']
          new_invoice.cod_fil_erp = param['codfil']
          new_invoice.cod_snf_erp = param['codsnf']
          new_invoice.status = param['status']
          new_invoice.created_by_id = customer.account.created_by_id
          new_invoice.account_id = customer.account_id
          new_invoice.save
        end
      rescue StandardError => e
        { service: { message: e.message } }
      end
    end
  end
end
