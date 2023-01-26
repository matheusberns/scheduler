# frozen_string_literal: true

module Homepages::ProductDerivations
  class ShowSerializer < BaseSerializer
    attributes :code,
               :multiple_quantity,
               :product,
               :uuid

    def product
      return unless object.product_id

      {
        id: object.product_id,
        code: object.product_code
      }
    end
  end
end
