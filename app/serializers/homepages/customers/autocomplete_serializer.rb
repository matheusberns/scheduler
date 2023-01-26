# frozen_string_literal: true

module Homepages::Customers
  class AutocompleteSerializer < BaseSerializer
    attributes :name,
               :code
  end
end
