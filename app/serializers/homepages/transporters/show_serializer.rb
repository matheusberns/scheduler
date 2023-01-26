# frozen_string_literal: true

module Homepages::Transporters
  class ShowSerializer < BaseSerializer
    attributes :name,
               :code,
               :cnpj,
               :uuid
  end
end
