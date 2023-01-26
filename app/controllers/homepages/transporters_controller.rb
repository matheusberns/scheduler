# frozen_string_literal: true

module Homepages
  class TransportersController < ::ApiController
    before_action :set_transporter, only: %i[show]

    def index
      @transporters = @current_user.transporters.list

      @transporters = apply_filters(@transporters, :by_homepage_search)

      render_index_json(@transporters, Transporters::IndexSerializer, 'transporters')
    end

    def show
      render_show_json(@transporter, Transporters::ShowSerializer, 'transporter', 200)
    end

    private

    def set_transporter
      @transporter = @current_user.transporters.show.find(params[:id])
    end
  end
end
