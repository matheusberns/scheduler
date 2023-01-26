# frozen_string_literal: true

class Invoice < ApplicationRecord
  # Concerns

  # Active storage
  has_one_attached :file_danfe
  has_one_attached :file_xml

  # Enumerations
  has_enumeration_for :status, with: ::StatusInvoiceTypeEnum, create_helpers: true, required: false, skip_validation: true
  has_enumeration_for :invoice_type, with: ::InvoiceTypeEnum, create_helpers: true, required: false, skip_validation: true

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :invoices, foreign_key: :account_id
  belongs_to :customer, -> { activated }, class_name: '::Customer', inverse_of: :invoices, foreign_key: :customer_id

  # Has_many associations

  # Many-to-many associations
  has_many :order_invoices, class_name: '::Many::OrderInvoice', inverse_of: :invoice, foreign_key: :invoice_id, dependent: :destroy
  has_many :installments, class_name: '::Installment', inverse_of: :invoice, foreign_key: :invoice_id, dependent: :destroy

  # Has-many through

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{Account.table_name}.invoice_file_url_fixed account_invoice_file_url_fixed")
      .select("#{::Customer.table_name}.name customer_name")
      .joins(:account, :customer)
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .select("#{Account.table_name}.invoice_file_url_fixed account_invoice_file_url_fixed")
      .select("#{::Customer.table_name}.name customer_name")
      .joins(:account, :customer)
      .traceability
  }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_invoice_type, ->(invoice_type) { where(invoice_type: invoice_type) }
  scope :by_purchase_order, ->(purchase_order) { where(purchase_order: purchase_order) }
  scope :by_invoice_number, ->(invoice_number) { where(invoice_number: invoice_number) }
  scope :by_emission_date, lambda { |start_date, end_date|
    start_date = Date.parse(start_date).strftime('%Y-%m-%d') if start_date
    end_date = Date.parse(end_date).strftime('%Y-%m-%d') if end_date

    if start_date && end_date
      where("DATE(#{table_name}.emission_date) >= :start_date and DATE(#{table_name}.emission_date) <= :end_date", start_date: start_date, end_date: end_date)
    elsif start_date
      where("DATE(#{table_name}.emission_date) >= :start_date", start_date: start_date)
    elsif end_date
      where("DATE(#{table_name}.emission_date) <= :end_date", end_date: end_date)
    end
  }
  scope :by_customer_id, ->(customer_id) { where(customer_id: customer_id) }
  scope :without_installments, -> { where("NOT EXISTS(SELECT 1 FROM #{Installment.table_name} WHERE #{Installment.table_name}.invoice_id = #{table_name}.id)") }

  # Callbacks

  # Validations
  validates_presence_of :invoice_number
  validates_presence_of :total_value
  validates_presence_of :emission_date
  validates_presence_of :invoice_type
end
