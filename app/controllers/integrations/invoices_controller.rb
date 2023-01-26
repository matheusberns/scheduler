# frozen_string_literal: true

module Integrations
  class InvoicesController < ::ApiController
    def create
      invoice_params.each do |invoice|
        customer = ::Customer.find_by({ code: invoice['customer']['code'] })

        return unless customer

        new_invoice = ::Invoice.find_or_initialize_by({ invoice_number: invoice['invoice_number'] })
        new_invoice.customer_id = customer.id
        new_invoice.total_value = invoice['total_value']
        new_invoice.emission_date = invoice['emission_date']
        new_invoice.invoice_type = invoice['invoice_type']
        new_invoice.purchase_order = invoice['purchase_order']
        new_invoice.danfe_url = invoice['danfe_url']
        new_invoice.xml_url = invoice['xml_url']
        new_invoice.status = invoice['status']
        new_invoice.created_by_id = @current_user.id
        new_invoice.account_id = @current_user.account_id

        new_invoice.save!
      end
      render json: invoice_params.pluck(:invoice_number).join(',')
    end

    private

    def invoice_params
      params.require(:invoices)
    end
  end
end
