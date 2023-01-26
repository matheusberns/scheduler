# frozen_string_literal: true

module Homepages
  class ProductsController < ::ApiController
    before_action :set_product, only: %i[show update]

    def index
      @products = @current_user.account.products.activated.list

      @products = apply_filters(@products, :by_homepage_search,
                                :by_search)

      render_index_json(@products, Products::IndexSerializer, 'products')
    end

    def show
      render_show_json(@product, Products::ShowSerializer, 'product', 200)
    end

    def update
      if @product.update(file: params[:products][:file])
        render_show_json(@product, Products::ShowSerializer, 'product', 200)
      else
        render_errors_json(@product.errors.messages)
      end
    end

    private

    def set_product
      @product = @current_user.account.products.show.find(params[:id])
    end
  end
end
