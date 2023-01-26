# frozen_string_literal: true

module Ibge
  class State < Base
    def find
      request = self.class.get('/localidades/estados', @options)
      return unless request.ok?

      @ibge_states = request.parsed_response.map(&:deep_symbolize_keys!)
    end

    def import
      @ibge_states.each do |ibge_state|
        state = ::Region::State.activated.find_or_initialize_by(uf: ibge_state[:sigla])
        state.name = ibge_state[:nome]
        state.save
      end
    end

    private

    def initialize
      @options = { headers: { 'Content-Type' => 'application/json' } }
    end
  end
end
