# frozen_string_literal: true

module Integrations
  class Budget < ::Integrations::Base
    def budget(budget: nil, external_service: nil)
      return { success: false, message: 'Problemas ao tentar sincronizar orçamento' } unless budget

      ::Integrations::Authentication.new.auth(external_service: external_service)
      session = Rails.cache.read('auth-session')

      return 'Você precisa estar autenticado' unless session

      budget_items = []
      if budget.budget_items.any?
        budget.budget_items.list.map do |budget_item|
          budget_items << {
            'quantity' => budget_item.quantity,
            'product_code' => budget_item.product_code,
            'product_derivation' => budget_item.product_derivation_code
          }
        end
      end

      budget = {
        purchase_order: budget.purchase_order,
        budget_items: budget_items,
        customer: {
          code: budget.customer.code
        }
      }

      response = self.class.post(
        "#{base_url}/api/portal_integrations/budgets",
        headers: {
          'Content-Type' => 'application/json',
          'access-token' => session['access-token'],
          'client' => session['client'],
          'uid' => session['uid'],
          'authkey' => session['authkey']
        },
        verify: false,
        timeout: 5000,
        body: { budget: budget }.to_json
      )

      if response.code == 201
        { success: true, message: 'Orçamento sincronizado com sucesso' }
      else
        { success: false, message: 'Problemas ao tentar sincronizar orçamento' }
      end
    rescue StandardError => e
      { budget: { message: e.message } }
    end
  end
end
