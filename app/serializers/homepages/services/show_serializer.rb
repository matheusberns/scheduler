# frozen_string_literal: true

module Homepages::Services
  class ShowSerializer < BaseSerializer
    attributes :date,
               :service_type,
               :status,
               :description,
               :uuid,
               :responsible,
               :service_subtype,
               :attachments,
               :customer

    def responsible
      return unless object.responsible

      {
        id: object.responsible_id,
        name: object.responsible_name
      }
    end

    def attachments
      object.attachments.map do |file|
        {
          id: file.id,
          url: rails_blob_path(file, only_path: true),
          content_type: file.blob.content_type,
          filename: file.blob[:filename]
        }
      end
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
