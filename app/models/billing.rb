# frozen_string_literal: true

class Billing < ApplicationRecord
  # Concerns

  # Active storage
  has_one_attached :billet

  # Enumerations
  has_enumeration_for :status, with: ::BillingStatusEnum, create_helpers: true, required: false, skip_validation: true

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :billings, foreign_key: :account_id
  belongs_to :order, -> { activated }, class_name: '::Order', inverse_of: :billings, foreign_key: :order_id, optional: true
  belongs_to :customer, -> { activated }, class_name: '::Customer', inverse_of: :billings, foreign_key: :customer_id

  # Has_many associations

  # Many-to-many associations

  # Has-many through

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{::Customer.table_name}.name customer_name")
      .select("#{::Order.table_name}.order_number order_number")
      .select("#{Account.table_name}.billet_file_url_fixed account_billet_file_url_fixed")
      .joins(:customer, :account)
      .left_outer_joins(:order)
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .select("#{::Customer.table_name}.name customer_name")
      .select("#{::Order.table_name}.order_number order_number")
      .select("#{Account.table_name}.billet_file_url_fixed account_billet_file_url_fixed")
      .joins(:customer, :account)
      .left_outer_joins(:order)
      .traceability
  }

  scope :by_billing_number, ->(billing_number) { where("#{table_name}.billing ILIKE :billing_number", billing_number: "%#{billing_number}%") }
  scope :by_invoice_number, ->(invoice_number) { where(invoice_number: invoice_number) }
  scope :by_status, ->(status) {
    if status.to_i == 5
      where(status: [::BillingStatusEnum::OPEN, ::BillingStatusEnum::LATE])
    else
      where(status: status)
    end
  }
  scope :by_order_number, ->(order_number) { where(orders: { order_number: order_number }) }
  scope :by_date, lambda { |start_date, end_date|
    start_date = Date.parse(start_date).strftime('%Y-%m-%d') if start_date
    end_date = Date.parse(end_date).strftime('%Y-%m-%d') if end_date

    if start_date && end_date
      where("DATE(#{table_name}.due_date) >= :start_date and DATE(#{table_name}.due_date) <= :end_date", start_date: start_date, end_date: end_date)
    elsif start_date
      where("DATE(#{table_name}.due_date) >= :start_date", start_date: start_date)
    elsif end_date
      where("DATE(#{table_name}.due_date) <= :end_date", end_date: end_date)
    end
  }
  scope :by_customer_id, ->(customer_id) { where(customer_id: customer_id) }

  # Callbacks

  # Validations
  validates_presence_of :billing
  validates_presence_of :due_date
end
