# frozen_string_literal: true

module Regions
  class StatesController < ::ApiController
    def index
      @states = ::Region::State.list

      @states = apply_filters(@states, :active_boolean,
                              :by_name,
                              :by_search,
                              :by_id,
                              :by_uf)

      render_index_json(@states, ::Regions::States::IndexSerializer, 'states')
    end
  end
end
