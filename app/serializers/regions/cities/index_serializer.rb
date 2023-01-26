# frozen_string_literal: true

module Regions
  module Cities
    class IndexSerializer < ActiveModel::Serializer
      attributes :id, :name, :state

      def state
        {
          uf: object.state_uf
        }
      end
    end
  end
end
