# frozen_string_literal: true

module Homepages
  class ProductDerivationsController < ::ApiController
    before_action :set_product_derivation, only: %i[show]

    def index
      @product_derivations = @current_user.account.product_derivations.list

      @product_derivations = apply_filters(@product_derivations, :by_product_id)

      render_index_json(@product_derivations, ProductDerivations::IndexSerializer, 'product_derivations')
    end

    def show
      render_show_json(@product_derivation, ProductDerivations::ShowSerializer, 'product_derivation', 200)
    end

    private

    def set_product_derivation
      @product_derivation = @current_user.account.product_derivations.show.find_by(params[:id])
    end
  end
end
