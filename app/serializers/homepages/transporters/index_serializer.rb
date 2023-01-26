# frozen_string_literal: true

module Homepages::Transporters
  class IndexSerializer < BaseSerializer
    attributes :name,
               :code,
               :cnpj,
               :uuid
  end
end
