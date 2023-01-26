# frozen_string_literal: true

class ImportInvoicesJob < ApplicationJob
  queue_as :import_invoices_job

  def self.scheduled(_queue, _klass, *_args)
    ImportInvoicesJob.import_invoices
  end

  def perform
    ImportInvoicesJob.import_invoices
  end

  def self.import_invoices
    ::Account.list.each do |account|
      account.external_services.where(integration_type: 3).each do |external_service|
        account.customers.each do |customer|
          ImportInvoicesJob.customer_import_invoices(external_service: external_service, customer: customer)
        end
      end
    end
  end

  def self.customer_import_invoices(external_service:, customer:)
    parameters = external_service.reload.parameters.gsub('@customer_code', customer.code)
    parameters = parameters.gsub('@emission_date', customer.invoices.any? ? Time.now.last_month.strftime('%Y-%m-%d') : '1900-01-01')

    get = Sapiens::Get.new.connection(base_url: external_service.base_url, parameters: parameters)
    Sapiens::Insert::Invoice.new.connection(get, customer)
  end
end
