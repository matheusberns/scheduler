# frozen_string_literal: true

module Homepages
  class RepresentativesController < ::ApiController
    before_action :set_representative, only: %i[show to_pdf to_xml]

    def index
      @representatives = @current_user.representatives.list

      @representatives = apply_filters(@representatives, :by_representative_number,
                                       :by_purchase_order,
                                       :by_status,
                                       :by_emission_date_date_range)

      render_index_json(@representatives, ::Homepages::Representatives::IndexSerializer, 'representatives')
    end

    def show
      render_show_json(@representative, ::Homepages::Representatives::ShowSerializer, 'representative', 200)
    end

    private

    def set_representative
      @representative = @current_user.representatives.show.find(params[:id])
    end
  end
end
