# frozen_string_literal: true

module Homepages::Orders
  class OrderItemsController < BaseController
    before_action :set_order_item, only: :show

    def index
      @order_items = @order.order_items.list

      @order_items = apply_filters(@order_items, :by_homepage_search)

      render_index_json(@order_items, ::Homepages::Orders::OrderItems::IndexSerializer, 'order_items')
    end

    def show
      render_show_json(@order_item, ::Homepages::Orders::OrderItems::ShowSerializer, 'order_item', 200)
    end

    private

    def set_order_item
      @order_item = @order.order_items.show.find(params[:id])
    end
  end
end
