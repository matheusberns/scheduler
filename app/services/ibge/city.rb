# frozen_string_literal: true

module Ibge
  class City < Base
    def find
      request = self.class.get("/localidades/estados/#{@state.uf}/municipios", @options)
      return unless request.ok?

      @ibge_cities = request.parsed_response.map(&:deep_symbolize_keys!)
    end

    def import
      @ibge_cities.each do |ibge_city|
        city = @state.cities.activated.find_or_initialize_by(ibge_code: ibge_city[:id])
        city.name = ibge_city[:nome]
        city.save
      end
    end

    private

    def initialize(state:)
      @state = state
      @options = { headers: { 'Content-Type' => 'application/json' } }
    end
  end
end
