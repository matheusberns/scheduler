# frozen_string_literal: true

module Sapiens
  class BilletReport
    def send
      connection = Sapiens::Connection.new(wsdl: build_wsdl, xml: build_xml)
      request = connection.call_gera_boleto

      request_error = request.body.dig(:gera_boleto_response, :result, :erro_execucao)

      return if request_error.present?

      save_file_danfe request.body.dig(:gera_boleto_response, :result, :retorno)
    end

    private

    def initialize(billing, web_service)
      @billing = billing
      @web_service = web_service
    end

    def save_file_danfe(retorno)
      file_name = retorno.split('\\').last.strip

      @billing.billet&.attach(io: File.open("public/BOLETOS/#{file_name}"), filename: file_name)
      @billing.update(has_file_billet: true)
    end

    def build_wsdl
      @web_service.url_base.to_s + @web_service.wsdl.to_s
    end

    def build_xml
      "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' "\
        "xmlns:ser='http://services.senior.com.br' "\
        "xmlns:xsd='http://www.w3.org/2001/XMLSchema' "\
        "xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>"\
        '<soapenv:Body>'\
          '<ser:GeraBoleto>'\
            "<user>#{@web_service.user}</user>"\
            "<password>#{@web_service.password}</password>"\
            '<encryption>0</encryption>'\
            '<parameters>'\
              "<codigoEmpresa>#{@billing.company_code}</codigoEmpresa>"\
              "<tipoTitulo>#{@billing.billing_type}</tipoTitulo>"\
              "<numeroTitulo>#{@billing.billing}</numeroTitulo>"\
              "<codigoPortador>#{@billing.holder_code}</codigoPortador>"\
              "<codigoCarteira>#{@billing.wallet}</codigoCarteira>"\
            '</parameters>'\
          '</ser:GeraBoleto>'\
        '</soapenv:Body>'\
      '</soapenv:Envelope>'
    end
  end
end

# "<codigoEmpresa>1</codigoEmpresa>"\
#               "<tipoTitulo>01</tipoTitulo>"\
#               "<numeroTitulo>60736.01</numeroTitulo>"\
#               "<codigoPortador>341</codigoPortador>"\
#               "<codigoCarteira>01</codigoCarteira>"\