# frozen_string_literal: true

module Homepages::Orders::OrderItems
  class IndexSerializer < BaseSerializer
    attributes :quantity,
               :product,
               :uuid,
               :purchase_order,
               :unit_price,
               :final_value,
               :fcp_value,
               :ics_value,
               :ipi_percentage,
               :situation_item,
               :price_table,
               :product_derivation

    def situation_item
      return unless object.situation_item

      {
        id: object.situation_item,
        name: object.situation_item_humanize
      }
    end

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
