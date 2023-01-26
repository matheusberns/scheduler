# frozen_string_literal: true

class Order < ApplicationRecord
  # Concerns
  include Age

  # Active storage
  has_one_attached :xls_file
  has_one_attached :pdf_file

  # Enumerations
  has_enumeration_for :situation, with: ::OrderSituationEnum, create_helpers: { prefix: true }, required: false
  has_enumeration_for :freight_type, with: ::FreightTypeEnum, create_helpers: { prefix: true }, required: false

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :orders, foreign_key: :account_id, required: false
  belongs_to :transporter, -> { activated }, class_name: '::Transporter', inverse_of: :orders, foreign_key: :transporter_id, required: false
  belongs_to :payment_condition, -> { activated }, class_name: '::PaymentCondition', inverse_of: :orders, foreign_key: :payment_condition_id, required: false
  belongs_to :customer, -> { activated }, class_name: '::Customer', inverse_of: :orders, foreign_key: :customer_id, required: false
  belongs_to :budget, -> { activated }, class_name: '::Budget', inverse_of: :orders, foreign_key: :budget_id, required: false

  # Has_many associations
  has_many :order_items, -> { activated }, class_name: '::OrderItem', inverse_of: :order, foreign_key: :order_id
  has_many :billings, -> { activated }, class_name: '::Billing', inverse_of: :order, foreign_key: :order_id
  has_many :order_ratings, -> { activated }, class_name: '::OrderRating', inverse_of: :order, foreign_key: :order_id
  has_many :budgets, -> { activated }, class_name: '::Budget', inverse_of: :order, foreign_key: :order_id

  # Many-to-many associations
  has_many :order_invoices, -> { activated }, class_name: '::Many::OrderInvoice', inverse_of: :order, foreign_key: :order_id

  # Has-many through

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{::Customer.table_name}.name customer_name")
      .joins(:customer)
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .select("#{::Transporter.table_name}.name transporter_name")
      .select("#{::PaymentCondition.table_name}.name payment_condition_name")
      .select("#{::Customer.table_name}.name customer_name")
      .left_outer_joins(:transporter)
      .left_outer_joins(:payment_condition)
      .joins(:customer)
      .traceability
  }
  scope :by_situation, ->(situation) { where(situation: situation) }
  scope :by_purchase_order, ->(purchase_order) { where(purchase_order: purchase_order) }
  scope :by_order_number, ->(order_number) { where(order_number: order_number) }
  scope :by_date, lambda { |start_date, end_date|
    start_date = Date.parse(start_date).strftime('%Y-%m-%d') if start_date
    end_date = Date.parse(end_date).strftime('%Y-%m-%d') if end_date

    if start_date && end_date
      where("DATE(#{table_name}.order_date) >= :start_date and DATE(#{table_name}.order_date) <= :end_date", start_date: start_date, end_date: end_date)
    elsif start_date
      where("DATE(#{table_name}.order_date) >= :start_date", start_date: start_date)
    elsif end_date
      where("DATE(#{table_name}.order_date) <= :end_date", end_date: end_date)
    end
  }
  scope :by_customer_id, ->(customer_id) { where(customer_id: customer_id) }

  # Callbacks

  # Validations
  validates_presence_of :budget_date
  validates_presence_of :value
  validates_presence_of :freight_type
end
