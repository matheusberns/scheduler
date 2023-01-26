# frozen_string_literal: true

module Homepages::Products
  class ShowSerializer < BaseSerializer
    attributes :name,
               :code,
               :code_name,
               :uuid

    def code_name
      "#{object.code} - #{object.name}"
    end
  end
end
