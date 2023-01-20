# frozen_string_literal: true

module Regions
  class ViaCepsController < ::ApiController
    def index
      @via_cep = ViaCep::Cep.new(cep: params[:cep])
      address = @via_cep.find

      render json: {
        'address' => address
      }, status: 200
    end
  end
end
