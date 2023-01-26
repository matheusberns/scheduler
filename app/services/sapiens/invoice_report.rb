# frozen_string_literal: true

module Sapiens
  class InvoiceReport
    def send
      connection = Sapiens::Connection.new(wsdl: build_wsdl, xml: build_xml)
      request = connection.call_reports

      request_error = request.body.dig(:executar_response, :result, :erro_execucao)

      return if request_error.present?

      save_file_danfe request
    end

    private

    def initialize(invoice, web_service_report)
      @invoice = invoice
      @web_service_report = web_service_report
      @web_service = web_service_report.web_service
    end

    def save_file_danfe(request)
      tempfile = Tempfile.new
      tempfile.binmode
      tempfile.write(Base64.decode64(request.body[:executar_response][:result][:pr_retorno]))
      tempfile.rewind

      @invoice.file_danfe.attach(io: File.open(tempfile.path), filename: "#{@invoice.invoice_number}.pdf")
      @invoice.update(has_file_danfe: true )
    end

    def build_wsdl
      @web_service.url_base.to_s + @web_service.wsdl.to_s
    end

    def build_input_message
      @web_service_report.reload.input_variables.tap do |input|
        input.gsub!('@cod_emp', @invoice.cod_emp_erp.to_s)
        input.gsub!('@cod_fil', @invoice.cod_fil_erp.to_s)
        input.gsub!('@cod_snf', @invoice.cod_snf_erp.to_s)
        input.gsub!('@num_nfv', @invoice.invoice_number.to_s)
      end
    end

    def build_xml
      "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' "\
        "xmlns:ser='http://services.senior.com.br' "\
        "xmlns:xsd='http://www.w3.org/2001/XMLSchema' "\
        "xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>"\
        '<soapenv:Body>'\
          '<ser:Executar>'\
            "<user>#{@web_service.user}</user>"\
            "<password>#{@web_service.password}</password>"\
            '<encryption>0</encryption>'\
            '<parameters>'\
              "<prFileName>#{@invoice.invoice_number}.pdf</prFileName>"\
              "<prRelatorio>#{@web_service_report.code}</prRelatorio>"\
              "<prEntrada>#{build_input_message}</prEntrada>"\
              '<prFileExt>PDF</prFileExt>'\
              '<prExecFmt>tefFile</prExecFmt>'\
              '<prSaveFormat>tsfPDF</prSaveFormat>'\
              '<prEntranceIsXML>F</prEntranceIsXML>'\
            '</parameters>'\
          '</ser:Executar>'\
        '</soapenv:Body>'\
      '</soapenv:Envelope>'
    end
  end
end
