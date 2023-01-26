# frozen_string_literal: true

class ImportBillingsJob < ApplicationJob
  queue_as :import_billings_job

  def self.scheduled(_queue, _klass, *_args)
    ImportBillingsJob.import_billings
  end

  def perform
    ImportBillingsJob.import_billings
  end

  def self.import_billings
    ::Account.list.each do |account|
      account.external_services.where(integration_type: 4).each do |external_service|
        account.customers.each do |customer|
          ImportBillingsJob.customer_import_billings(external_service: external_service, customer: customer)
        end
      end
    end
  end

  def self.customer_import_billings(external_service:, customer:)
    parameters = external_service.reload.parameters.gsub('@customer_code', customer.code)
    parameters = parameters.gsub('@emission_date', customer.billings.any? ? Time.now.last_month.strftime('%Y-%m-%d') : '1900-01-01')

    get = Sapiens::Get.new.connection(base_url: external_service.base_url, parameters: parameters)
    Sapiens::Insert::Billing.new.connection(get, customer)
  end
end
