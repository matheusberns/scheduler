# frozen_string_literal: true

module Homepages::Invoices
  class IndexSerializer < BaseSerializer
    attributes :invoice_number,
               :total_value,
               :emission_date,
               :invoice_type,
               :purchase_order,
               :customer,
               :status,
               :uuid,
               :file_danfe,
               :file_xml

    def invoice_number
      object.service_number || object.invoice_number
    end

    def invoice_type
      return unless object.invoice_type

      {
        id: object.invoice_type,
        name: object.invoice_type_humanize
      }
    end

    def status
      return unless object.status

      {
        id: object.status,
        name: object.status_humanize
      }
    end

    def file_danfe
      if object.account_invoice_file_url_fixed
         {
           id: Time.now.to_i,
           url: object.danfe_url,
           content_type: 'application/pdf'
         }
      else
        return unless object.file_danfe.attached?

        {
          id: object.file_danfe.id,
          url: Rails.application.routes.url_helpers.rails_blob_path(object.file_danfe, only_path: true),
          content_type: object.file_danfe.blob.content_type
        }
      end
    end

    def file_xml
      if object.account_invoice_file_url_fixed
        {
          id: Time.now.to_i,
          url: object.xml_url,
          content_type: 'application/xml'
        }
      else
        return unless object.file_xml.attached?

        {
          id: object.file_xml.id,
          url: Rails.application.routes.url_helpers.rails_blob_path(object.file_xml, only_path: true),
          content_type: object.file_xml.blob.content_type
        }
      end
    end

    def customer
      {
        id: object.customer_id,
        name: object.customer_name
      }
    end
  end
end
