# frozen_string_literal: true

class Mailer < ApplicationMailer
  def mailer_notification(notification)
    @notification = notification
    mail(to: [@notification.from.email])
  end

  def send_integration_budget_mail(budget: nil)
    return if budget

    @budget = budget

    mail(to: 'matheus.berns@velow.com.br', subject: 'Problemas ao tentar integrar orçamento', from: 'enviador@portal.com.br')
  end
end
