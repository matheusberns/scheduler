# frozen_string_literal: true

module Homepages::Billings
  class ShowSerializer < BaseSerializer
    attributes :billing,
               :due_date,
               :open_days,
               :amount,
               :value,
               :order,
               :status,
               :emission_date,
               :invoice_number,
               :order_number,
               :uuid,
               :billet,
               :customer

    def value
      object.amount
    end

    def open_days
      return unless object.due_date
      return if [::BillingStatusEnum::PAID, ::BillingStatusEnum::CANCEL].include?(object.status)

      (Date.today - object.due_date.to_date).to_i
    end

    def status
      return unless object.status

      if (Date.today > object.due_date.to_date) && ![::BillingStatusEnum::PAID, ::BillingStatusEnum::CANCEL].include?(object.status)
        enum = ::BillingStatusEnum.to_a.find { |object| object[1] == ::BillingStatusEnum::LATE }

        { id: enum[1], name: enum[0] }
      else
        {
          id: object.status,
          name: object.status_humanize
        }
      end
    end

    def order
      return unless object.order_id

      {
        id: object.order_id,
        order_number: object.order_number
      }
    end

    def billet
      return unless object.billet.attached?

      {
        id: object.billet.id,
        url: Rails.application.routes.url_helpers.rails_blob_path(object.billet, only_path: true),
        content_type: object.billet.blob.content_type
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
