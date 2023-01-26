# frozen_string_literal: true

module Consults
  class Cpf < ::Consults::Base
    def initialize(cpf:)
      @options = {
        headers: {
          'Content-Type' => 'application/json',
          'authkey' => CONSULT_DOCUMENT_AUTH_KEY,
          'appid' => '1'
        },
        query: { cpf: cpf }
      }
    end

    def get
      self.class.get('/people/by_cpf', @options)
    end
  end
end
