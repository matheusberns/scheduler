# frozen_string_literal: true

class Account < ApplicationRecord
  attr_accessor :portal_account

  # Concerns

  # Active storage
  has_one_attached :logo
  has_one_attached :menu_background
  has_one_attached :toolbar_background

  # Enumerations

  # Belongs_to associations

  # Has_many associations
  has_many :customers, class_name: '::Customer', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :users, class_name: '::User', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :notifications, class_name: '::Notification', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :notification_tokens, class_name: '::NotificationToken', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :payment_conditions, class_name: '::PaymentCondition', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :transporters, class_name: '::Transporter', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :orders, class_name: '::Order', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :order_items, class_name: '::OrderItem', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :integrations, class_name: '::Integration', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :invoices, class_name: '::Invoice', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :billings, class_name: '::Billing', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :services, class_name: '::Service', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :installments, class_name: '::Installment', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :order_ratings, class_name: '::OrderRating', inverse_of: :account, foreign_key: :account_id
  has_many :user_logs, class_name: '::UserLog', inverse_of: :account, foreign_key: :account_id
  has_many :products, class_name: '::Product', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :product_derivations, class_name: '::ProductDerivation', inverse_of: :account, foreign_key: :account_id
  has_many :budgets, class_name: '::Budget', inverse_of: :account, foreign_key: :account_id
  has_many :budget_items, class_name: '::BudgetItem', inverse_of: :account, foreign_key: :account_id
  has_many :representatives, class_name: '::Representative', inverse_of: :account, foreign_key: :account_id
  has_many :contacts, class_name: '::Contact', inverse_of: :account, foreign_key: :account_id
  has_many :external_services, class_name: '::ExternalService', inverse_of: :account, foreign_key: :account_id
  has_many :web_services, class_name: '::WebService', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :web_service_reports, class_name: '::WebServiceReport', inverse_of: :account, foreign_key: :account_id, dependent: :destroy

  # Many-to-many associations
  has_many :order_invoices, class_name: '::Many::OrderInvoice', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :all_account_tools, class_name: 'Many::AccountTool', foreign_key: :account_id, dependent: :destroy
  has_many :account_tools, -> { activated }, class_name: 'Many::AccountTool', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :tools, through: :account_tools

  # Has-many through

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .traceability
      .include_images
  }
  scope :autocomplete, lambda {
    select(:id, :name)
  }
  scope :by_name, lambda { |name|
    where("UNACCENT(#{table_name}.name) ILIKE :name",
          name: "%#{I18n.transliterate(name)}%")
  }
  scope :include_images, lambda {
    includes(logo_attachment: :blob)
    includes(menu_background_attachment: :blob)
    includes(toolbar_background_attachment: :blob)
  }
  scope :by_search, ->(search) { by_name(search) }
  scope :by_uuid, ->(uuid) { where("CAST(#{table_name}.uuid as TEXT) ILIKE :uuid", uuid: "%#{uuid}%") }

  # Callbacks
  before_validation :find_portal_account
  after_create :default_setup
  after_create_commit :set_logo_from_account

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates_uniqueness_of :uuid, conditions: -> { activated }
  validates_presence_of :base_url
  validates_uniqueness_of :base_url, conditions: -> { activated }
  validates_numericality_of :timeout_in, only_integer: true, less_than_or_equal_to: 9999, allow_nil: true
  validates :smtp_user, :smtp_password, :smtp_host, :smtp_email,
            :active_directory_host,
            :active_directory_base, :active_directory_domain,
            length: { maximum: 255 }
  validates :active_directory_host,
            :active_directory_base,
            :active_directory_domain,
            presence: true,
            if: :is_active_directory

  validate :check_uuid, on: :create

  def active_directory?
    is_active_directory
  end

  private

  def find_portal_account
    return if Rails.env.test?

    account_request = ::Accounts::AccountConsult.new(uuid: uuid).find
    return unless account_request[:success]

    self.portal_account = account_request[:account]

    self.name = portal_account[:company_name]
    self.api_base_url = portal_account.dig(:portal_config, :base_url)
    self.base_url = portal_account.dig(:portal_config, :base_url_web)
  end

  def check_uuid
    errors.add(:uuid, :invalid) unless portal_account.present? || Rails.env.test?
  end

  def set_logo_from_account
    return unless portal_account.present?
    return unless portal_account.dig(:image, :url).present?

    full_url = VELOW_ACCOUNTS_URL + portal_account.dig(:image, :url)
    downloaded_image = URI.parse(full_url).open
    logo.attach(io: downloaded_image, filename: Time.now.iso8601.to_s)
  end

  def default_setup
    ::AccountDefaultSetupJob.perform_now(self) unless Rails.env.test?
  end
end
