class ImportCustomersJob < ApplicationJob
  queue_as :import_customers_job

  def self.scheduled(_queue, _klass, *_args)
    ImportCustomersJob.import_customers
  end

  def perform
    ImportCustomersJob.import_customers
  end

  def self.import_customers
    ::Account.list.each do |account|
      account.external_services.where(integration_type: 2).each do |external_service|
        get = Sapiens::Get.new.connection(base_url: external_service.base_url, parameters: external_service.parameters)
        Sapiens::Insert::Customer.new.connection(get, account)
      end
    end
  end
end
