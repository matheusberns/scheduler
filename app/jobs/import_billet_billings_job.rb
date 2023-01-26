# frozen_string_literal: true

class ImportBilletBillingsJob < ApplicationJob
  queue_as :import_billet_billings_job

  def self.scheduled(_queue, _klass, *_args)
    ImportBilletBillingsJob.import_billet_billings
  end

  def perform
    ImportBilletBillingsJob.import_billet_billings
  end

  def self.import_billet_billings
    ::Account.list.activated.each do |account|
      web_service = account.web_services.list.activated.where.not(wsdl: nil).find_by(web_service_type: ::WebServiceTypeEnum::BILLET)
      next if web_service.nil?

      account.billings.where(has_file_billet: false).where(status: [1, 2, 5]).where.not(holder_code: 9999).limit(20).each do |billing|
        begin
          Sapiens::BilletReport.new(billing, web_service).send
        rescue
          next
        end
      end
    end

  end
end
