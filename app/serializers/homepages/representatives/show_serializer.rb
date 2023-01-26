# frozen_string_literal: true

module Homepages::Representatives
  class ShowSerializer < BaseSerializer
    attributes :code,
               :name,
               :email
  end
end
