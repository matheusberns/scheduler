class ImportInstallmentsJob < ApplicationJob
  queue_as :import_installments_job

  def self.scheduled(_queue, _klass, *_args)
    ImportInstallmentsJob.import_installments
  end

  def perform
    ImportInstallmentsJob.import_installments
  end

  def self.import_installments
    ::Account.list.each do |account|
      account.external_services.where(integration_type: 5).each do |external_service|
        account.customers.each do |customer|
          customer.invoices.without_installments.each do |invoice|
            parameters = external_service.parameters.gsub('@invoice_number', invoice.invoice_number)

            get = Sapiens::Get.new.connection(base_url: external_service.base_url, parameters: parameters)
            Sapiens::Insert::Installment.new.connection(get, invoice)
          end
        end
      end
    end
  end
end
