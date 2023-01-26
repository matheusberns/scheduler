# frozen_string_literal: true

module Homepages::Installments
  class ShowSerializer < BaseSerializer
    attributes :serial_number,
               :invoice_number,
               :code,
               :billing_number,
               :billing_type,
               :due_date,
               :amount,
               :uuid
  end
end
