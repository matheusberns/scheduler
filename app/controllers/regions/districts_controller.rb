# frozen_string_literal: true

module Regions
  class DistrictsController < ::ApiController
    def index
      @districts = ::Region::District.list

      @districts = apply_filters(@districts, :active_boolean,
                                 :by_city_id,
                                 :by_state_id,
                                 :by_search)

      render_index_json(@districts, ::Regions::Districts::IndexSerializer, 'districts')
    end
  end
end
