# frozen_string_literal: true

module Homepages
  class BillingsController < ::ApiController
    before_action :set_billing, only: %i[show generate_billet duplicate_billet]

    def index
      @billings = @account.billings.by_customer_id(@customer_ids).list

      @billings = apply_filters(@billings,
                                :by_order_number,
                                :by_billing_number,
                                :by_invoice_number,
                                :by_status,
                                :by_customer_id,
                                :by_date_date_range)

      render_index_json(@billings, ::Homepages::Billings::IndexSerializer, 'billings')
    end

    def show
      render_show_json(@billing, ::Homepages::Billings::ShowSerializer, 'billing', 200)
    end

    def generate_billet
      if @billing.generate_billet
        @current_user.create_log(description: "Gerado boleto do título: #{@billing.billing}")
        render_success_json
      else
        render_errors_json(@billing.errors.messages)
      end
    end

    def duplicate_billet
      if @billing.duplicate_billet
        @current_user.create_log(description: "Gerado segunda via do boleto do título: #{@billing.billing}")
        render_success_json
      else
        render_errors_json(@billing.errors.messages)
      end
    end

    private

    def set_billing
      @billing = @account.billings.by_customer_id(@customer_ids).show.find(params[:id])
    end
  end
end
