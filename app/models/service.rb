# frozen_string_literal: true

class Service < ApplicationRecord
  # Concerns

  # Active storage
  has_many_attached :attachments

  # Enumerations
  has_enumeration_for :service_subtype, with: ::ServiceSubtypeEnum, create_helpers: true, required: false, skip_validation: true
  has_enumeration_for :service_type, with: ::ServiceTypeEnum, create_helpers: true, required: false, skip_validation: true
  has_enumeration_for :status, with: ::ServiceStatusEnum, create_helpers: true, required: false, skip_validation: true

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :services, foreign_key: :account_id
  belongs_to :customer, -> { activated }, class_name: '::Customer', inverse_of: :services, foreign_key: :customer_id
  belongs_to :responsible, -> { activated }, class_name: '::User', inverse_of: :services, foreign_key: :responsible_id, required: false

  # Has_many associations

  # Many-to-many associations

  # Has-many through

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{::Customer.table_name}.name customer_name")
      .select("#{::User.table_name}.name responsible_name")
      .joins(:customer)
      .left_outer_joins(:responsible)
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .select("#{::Customer.table_name}.name customer_name")
      .select("#{::User.table_name}.name responsible_name")
      .joins(:customer)
      .left_outer_joins(:responsible)
  }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_service_type, ->(service_type) { where(service_type: service_type) }
  scope :by_service_id, ->(service_id) { where(id: service_id) }
  scope :by_date, lambda { |start_date, end_date|
    if start_date && end_date
      where("#{table_name}.date >= :start_date and #{table_name}.date <= :end_date", start_date: start_date, end_date: end_date)
    elsif start_date
      where("#{table_name}.date >= :start_date", start_date: start_date)
    elsif end_date
      where("#{table_name}.date <= :end_date", end_date: end_date)
    end
  }
  scope :by_customer_id, ->(customer_id) { where(customer_id: customer_id) }

  # Callbacks
  after_create :service_integration

  # Validations
  validates_presence_of :date
  validates_presence_of :description

  def service_integration
    return if Rails.env.development?

    response = ::Integrations::Service.new.service(service: self)

    Rails.logger.info "Resposta: #{response}"

    raise response[:message] unless response[:success]
  end
end
