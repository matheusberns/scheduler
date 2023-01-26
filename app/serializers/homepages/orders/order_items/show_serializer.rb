# frozen_string_literal: true

module Homepages::Orders::OrderItems
  class ShowSerializer < BaseSerializer
    attributes :quantity,
               :product,
               :uuid,
               :product_derivation

    def product
      return unless object.product_id

      {
        id: object.product_id,
        name: object.product_name,
        code: object.product_code
      }
    end

    def product_derivation
      return unless object.product_derivation_id

      {
        id: object.product_derivation_id,
        code: object.product_derivation_code
      }
    end
  end
end
