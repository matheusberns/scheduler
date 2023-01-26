# frozen_string_literal: true

class IntegrateBudgetsJob < ApplicationJob
  queue_as :integrate_budgets_job

  def self.scheduled(_queue, _klass, *_args)
    IntegrateBudgetsJob.integrate_budgets
  end

  def perform
    IntegrateBudgetsJob.integrate_budgets
  end

  def self.integrate_budgets
    ::Account.all.each do |account|
      external_service = account.external_services.find_by(integration_type: 6)

      return unless external_service

      account.budgets.where(status: 2).each do |budget|
        response = Integrations::Budget.new.budget(budget: budget, external_service: external_service)

        budget.update_columns(status: 3) if response[:success]
      end
    end
  end
end
