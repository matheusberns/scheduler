# frozen_string_literal: true

module Regions
  class CitiesController < ::ApiController
    def index
      @cities = ::Region::City.list

      @cities = apply_filters(@cities, :active_boolean,
                              :by_name,
                              :by_search,
                              :by_id,
                              :by_state_id)

      render_index_json(@cities, ::Regions::Cities::IndexSerializer, 'cities')
    end
  end
end
