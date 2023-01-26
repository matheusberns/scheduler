# frozen_string_literal: true

module Homepages
  class InvoicesController < ::ApiController
    before_action :set_invoice, only: %i[show to_pdf to_xml]

    def index
      @invoices = @account.invoices.by_customer_id(@customer_ids).list

      @invoices = apply_filters(@invoices, :by_invoice_number,
                                :by_purchase_order,
                                :by_status,
                                :by_emission_date_date_range)

      render_index_json(@invoices, ::Homepages::Invoices::IndexSerializer, 'invoices')
    end

    def show
      render_show_json(@invoice, ::Homepages::Invoices::ShowSerializer, 'invoice', 200)
    end

    private

    def set_invoice
      @invoice = @account.invoices.by_customer_id(@customer_ids).show.find(params[:id])
    end
  end
end
