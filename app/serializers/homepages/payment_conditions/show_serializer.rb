# frozen_string_literal: true

module Homepages::PaymentConditions
  class IndexSerializer < BaseSerializer
    attributes :name,
               :code,
               :uuid
  end
end
