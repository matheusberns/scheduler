# frozen_string_literal: true

module Homepages::Orders
  class IndexSerializer < BaseSerializer
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
               :pdf_file,
               :xls_file,
               :customer

    def situation
      return unless object.situation

      {
        id: object.situation,
        name: object.situation_humanize
      }
    end

    def freight_type
      return unless object.freight_type

      {
        id: object.freight_type,
        name: object.freight_type_humanize
      }
    end

    def pdf_file
      { url: "#{object.pdf_file_name}" }
    end

    def xls_file
      { url: "#{object.xls_file_name}" }
    end

    def customer
      {
        id: object.customer_id,
        name: object.customer_name
      }
    end
  end
end
