# frozen_string_literal: true

module Homepages::Orders::OrderRatings
  class IndexSerializer < BaseSerializer
    attributes :rating,
               :description,
               :rating_type
  end
end
