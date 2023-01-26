# frozen_string_literal: true

module Integrations
  class UserLog < ::Integrations::Base
    def user_log(customers:)
      account = ::Account.find(customers[0].account_id)

      external_service = account.external_services.find_by(integration_type: 7)
      return { success: false, message: 'Não existe um serviço externo para integrar o serviço' } unless external_service

      ::Integrations::Authentication.new.auth(external_service: external_service)
      session = Rails.cache.read('auth-session')

      user_logs = []

      customers.each do |customer|
        customer.user_logs.where('date > :date', date: Date.today.ctime).each do |user_log|
          user_logs << {
            'date' => user_log.date,
            'description' => user_log.description,
            'user_email' => user_log.user.email,
            'user_name' => user_log.user.name,
            'customer_code' => customer.code
          }
        end
      end

      return { success: true, message: 'Logs do cliente atualizados com sucesso' } unless user_logs.any?

      return 'Você precisa estar autenticado' unless session

      response = self.class.post(
        "#{base_url}/api/portal_integrations/user_logs",
        headers: {
          'Content-Type' => 'application/json',
          'access-token' => session['access-token'],
          'client' => session['client'],
          'uid' => session['uid'],
          'authkey' => session['authkey']
        },
        timeout: 5000,
        body: { user_logs: user_logs }.to_json
      )

      if response.code == 201
        { success: true, message: 'Logs do cliente atualizados com sucesso' }
      else
        { success: false, message: 'Problemas ao atualizar logs do cliente' }
      end
    rescue StandardError => e
      { user_log: { message: e.message } }
    end
  end
end
