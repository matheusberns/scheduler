# frozen_string_literal: true

module Homepages::Services
  class IndexSerializer < BaseSerializer
    attributes :date,
               :service_type,
               :status,
               :description,
               :uuid,
               :responsible,
               :service_subtype,
               :customer

    def responsible
      return unless object.responsible

      {
        id: object.responsible_id,
        name: object.responsible_name
      }
    end

    def service_type
      return unless object.service_type

      {
        id: object.service_type,
        name: object.service_type_humanize
      }
    end

    def service_subtype
      return unless object.service_subtype

      {
        id: object.service_type,
        name: object.service_type_humanize
      }
    end

    def status
      return unless object.status

      {
        id: object.status,
        name: object.status_humanize
      }
    end

    def customer
      {
        id: object.customer_id,
        name: object.customer_name
      }
    end
  end
end
