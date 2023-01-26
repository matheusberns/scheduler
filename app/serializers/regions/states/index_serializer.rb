# frozen_string_literal: true

module Regions
  module States
    class IndexSerializer < ActiveModel::Serializer
      attributes :id, :uf
    end
  end
end
