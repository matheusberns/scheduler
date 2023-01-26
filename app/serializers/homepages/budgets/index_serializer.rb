# frozen_string_literal: true

module Homepages::Budgets
  class IndexSerializer < BaseSerializer
    attributes :sequence,
               :purchase_order,
               :synchronized,
               :status,
               :representative,
               :customer,
               :uuid

    def purchase_order
      object.purchase_order.to_i
    end

    def customer
      return unless object.customer_id

      {
        id: object.customer_id,
        name: object.customer_name
      }
    end

    def representative
      return unless object.customer.representative_id

      {
        name: object.representative_name
      }
    end

    def status
      return unless object.status

      {
        id: object.status,
        name: object.status_humanize
      }
    end
  end
end
