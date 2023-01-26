# frozen_string_literal: true

module Homepages::Orders
  class ShowSerializer < BaseSerializer
    attributes :budget_date,
               :order_number,
               :order_date,
               :value,
               :situation,
               :purchase_order,
               :freight_type,
               :delivery_address,
               :freight_value,
               :delivery_forecast,
               :transporter,
               :payment_condition,
               :customer

    def freight_type
      return unless object.freight_type

      {
        id: object.freight_type,
        name: object.freight_type_humanize
      }
    end

    def transporter
      return unless object.transporter_id

      {
        id: object.transporter_id,
        name: object.transporter_name
      }
    end

    def payment_condition
      return unless object.payment_condition_id

      {
        id: object.payment_condition_id,
        name: object.payment_condition_name
      }
    end

    def customer
      {
        id: object.customer_id,
        name: object.customer_name
      }
    end

    def situation
      return unless object.situation

      {
        id: object.situation,
        name: object.situation_humanize
      }
    end
  end
end
