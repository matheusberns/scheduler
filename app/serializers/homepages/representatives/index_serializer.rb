# frozen_string_literal: true

module Homepages::Representatives
  class IndexSerializer < BaseSerializer
    attributes :code,
               :name,
               :email
  end
end
