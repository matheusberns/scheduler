# frozen_string_literal: true

module Homepages::Customers
  class InvoicesController < BaseController
    before_action :set_invoice, only: :show

    def index
      @invoices = @customer.invoices.list

      @invoices = apply_filters(@invoices, :by_homepage_search,
                                :by_invoice_type,
                                :by_status)

      render_index_json(@invoices, Homepages::Invoices::IndexSerializer, 'invoices')
    end

    def show
      render_show_json(@invoice, Homepages::Invoices::ShowSerializer, 'invoice', 200)
    end

    private

    def set_invoice
      @invoice = @customer.invoices.show.find(params[:id])
    end
  end
end
