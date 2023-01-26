# frozen_string_literal: true

module Homepages::Budgets::BudgetItems
  class ShowSerializer < BaseSerializer
    attributes :quantity,
               :product_derivation,
               :product,
               :budget,
               :uuid

    def product_derivation
      return unless object.product_derivation_id

      {
        id: object.product_derivation_id,
        code: object.product_derivation_code
      }
    end

    def budget
      return unless object.budget_id

      {
        id: object.budget_id,
        purchase_order: object.budget_purchase_order.to_i
      }
    end

    def product
      return unless object.product_id

      {
        id: object.product_id,
        code: object.product_code,
        name: object.product_name
      }
    end
  end
end
