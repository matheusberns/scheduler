# frozen_string_literal: true

module Consults
  class Cnpj < ::Consults::Base
    def initialize(cnpj:)
      @options = {
        headers: {
          'Content-Type' => 'application/json',
          'authkey' => CONSULT_DOCUMENT_AUTH_KEY,
          'appid' => '1'
        },
        query: { cnpj: cnpj }
      }
    end

    def get
      request = self.class.get('/companies/by_cnpj', @options)

      @request_object = request.deep_symbolize_keys

      if request.ok? && @request_object[:company]
        { success: true, company: @request_object[:company] }
      else
        { success: false, errors: @request_object[:errors] }
      end
    end

    private

    def strip_value(value)
      return value unless value.is_a? String

      value.strip
    end
  end
end
