# frozen_string_literal: true

require 'savon'

module Sapiens
  class Connection
    def call_reports
      @savon_client.call(
        :executar,
        xml: @xml
      )
    end

    def call_gera_boleto
      @savon_client.call(
        :gera_boleto,
        xml: @xml
      )
    end

    private

    def initialize(wsdl:, xml:)
      @wsdl = wsdl
      @xml = xml

      @savon_client = ::Savon.client(parameters)
    end

    def parameters
      {
        wsdl: @wsdl,
        env_namespace: :soapenv,
        namespace_identifier: :ser,
        pretty_print_xml: true,
        log: true,
        logger: Rails.logger,
        ssl_verify_mode: :none,
        log_level: :debug,
        read_timeout: 300,
        open_timeout: 300,
        follow_redirects: true
      }
    end
  end
end
