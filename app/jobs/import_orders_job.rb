class ImportOrdersJob < ApplicationJob
  queue_as :import_orders_job

  def perform
    ::Account.list.each do |account|
      external_service = account.external_services.find_by(integration_type: 2, name: 'Importar pedidos')

      return unless external_service

      get = Sapiens::Get.new.connection(external_service)
      Sapiens::Insert::Order.new.connection(get, account)
    end
  end
end
