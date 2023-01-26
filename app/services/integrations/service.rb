# frozen_string_literal: true

module Integrations
  class Service < ::Integrations::Base
    def service(service: nil)
      return { success: false, message: 'Problemas ao tentar sincronizar serviço' } unless service

      external_service = service.account.external_services.find_by(integration_type: 7)
      return { success: false, message: 'Não existe um serviço externo para integrar o serviço' } unless external_service

      ::Integrations::Authentication.new.auth(external_service: external_service)
      session = Rails.cache.read('auth-session')

      return 'Você precisa estar autenticado' unless session

      attachments = []
      service.attachments.map do |file|
        attachments << {
          id: file.id,
          url: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true),
          content_type: file.blob.content_type
        }
      end

      response = self.class.post(
        "#{base_url}/api/portal_integrations/services",
        headers: {
          'Content-Type' => 'application/json',
          'access-token' => session['access-token'],
          'client' => session['client'],
          'uid' => session['uid'],
          'authkey' => session['authkey']
        },
        timeout: 5000,
        body: {
          service: {
            'service_type' => service.service_type,
            'service_subtype' => service.service_subtype,
            'priority_type' => service.priority_type,
            'description' => service.description,
            customer: { 'code' => service.customer.code },
            attachments: attachments
          }
        }.to_json,
        verify: false
      )

      if response.code == 201
        { success: true, message: 'Serviço sincronizado com sucesso' }
      else
        { success: false, message: response }
      end
    rescue StandardError => e
      { success: false, message: e.message }
    end
  end
end
