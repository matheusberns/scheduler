# frozen_string_literal: true

module Homepages
  class OrdersController < ::ApiController
    before_action :set_order, only: %i[show to_pdf to_xls]

    def index
      @orders = @account.orders.by_customer_id(@customer_ids).list

      @orders = apply_filters(@orders, :by_purchase_order,
                              :by_order_number,
                              :by_situation,
                              :by_date_date_range)

      render_index_json(@orders, ::Homepages::Orders::IndexSerializer, 'orders')
    end

    def show
      render_show_json(@order, ::Homepages::Orders::ShowSerializer, 'order', 200)
    end

    private

    def set_order
      @order = @current_user.orders.show.find(params[:id])
    end
  end
end
