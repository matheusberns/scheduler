# frozen_string_literal: true

class Installment < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :installments, foreign_key: :account_id, required: false
  belongs_to :customer, -> { activated }, class_name: '::Customer', inverse_of: :installments, foreign_key: :customer_id, required: false
  belongs_to :invoice, -> { activated }, class_name: '::Invoice', inverse_of: :installments, foreign_key: :invoice_id, required: false

  # Has_many associations

  # Many-to-many associations

  # Has-many through

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .select("#{::Invoice.table_name}.invoice_number invoice_number")
      .select("#{::Customer.table_name}.name customer_name")
      .left_outer_joins(:customer)
      .left_outer_joins(:invoice)
      .traceability
  }
  scope :by_date, lambda { |start_date, end_date|
    start_date = Date.parse(start_date).strftime('%Y-%m-%d') if start_date
    end_date = Date.parse(end_date).strftime('%Y-%m-%d') if end_date

    if start_date && end_date
      where("#{table_name}.dat_ger >= :start_date and #{table_name}.dat_ger <= :end_date", start_date: start_date, end_date: end_date)
    elsif start_date
      where("#{table_name}.dat_ger >= :start_date", start_date: start_date)
    elsif end_date
      where("#{table_name}.dat_ger <= :end_date", end_date: end_date)
    end
  }

  # Callbacks

  # Validations
  validates_presence_of :serial_number
  validates_presence_of :invoice_number
  validates_presence_of :billing_number
  validates_presence_of :billing_type
end
