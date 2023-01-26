# frozen_string_literal: true

class ImportDanfeInvoicesJob < ApplicationJob
  queue_as :import_danfe_invoices_job

  def self.scheduled(_queue, _klass, *_args)
    ImportDanfeInvoicesJob.import_danfe_invoices
  end

  def perform
    ImportDanfeInvoicesJob.import_danfe_invoices
  end

  def self.import_danfe_invoices
    ::Account.list.activated.each do |account|
      web_service = account.web_services.list.activated.where.not(wsdl: nil).find_by(web_service_type: ::WebServiceTypeEnum::INVOICE)
      next if web_service.nil?

      account.invoices.where(has_file_danfe: false).order(emission_date: :desc).limit(50).each do |invoice|
        Sapiens::InvoiceReport.new(invoice, web_service.reports.last).send
      end
    end

  end
end
