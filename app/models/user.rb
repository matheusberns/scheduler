# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable, :omniauthable, :confirmable, :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :timeoutable, timeout_in: 15.minutes

  include DeviseTokenAuth::Concerns::User

  # Accessors
  attr_accessor :update_to_integration, :is_new_user

  # Concerns

  # Active storage
  has_one_attached :photo
  has_one_attached :driver_license_photo

  # Enumerations

  # Belongs_to associations
  belongs_to :customer, -> { activated }, class_name: '::Customer', inverse_of: :users, foreign_key: :customer_id, optional: true
  belongs_to :integration, -> { activated }, class_name: '::Integration', inverse_of: :users, foreign_key: :integration_id, optional: true
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :users, foreign_key: :account_id, optional: true
  belongs_to :state, -> { activated }, class_name: '::Region::State', inverse_of: :users, foreign_key: :state_id, optional: true
  belongs_to :city, -> { activated }, class_name: '::Region::City', inverse_of: :users, foreign_key: :city_id, optional: true

  # Has_many associations
  has_many :notifications, class_name: '::Notification', inverse_of: :user, foreign_key: :user_id
  has_many :notification_tokens, class_name: '::NotificationToken', inverse_of: :user, foreign_key: :user_id
  has_many :services, class_name: '::Services', inverse_of: :responsible, foreign_key: :responsible_id
  has_many :user_logs, class_name: '::UserLog', inverse_of: :user, foreign_key: :user_id

  # Many-to-many associations

  # Has-one through
  has_one :account_menu_background, through: :account, source: :menu_background_attachment
  has_one :account_toolbar_background, through: :account, source: :toolbar_background_attachment
  has_one :account_logo, through: :account, source: :logo_attachment

  # Has-many through
  has_many :transporters, through: :account
  has_many :representatives, through: :account
  has_many :orders, through: :customer
  has_many :invoices, through: :customer
  has_many :billings, through: :customer
  has_many :services, through: :customer
  has_many :budgets, through: :customer
  has_many :order_items, through: :orders

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{::Account.table_name}.primary_color account_primary_color")
      .select("#{::Account.table_name}.secondary_color account_secondary_color")
      .select("#{::Account.table_name}.primary_colors account_primary_colors")
      .select("#{::Account.table_name}.secondary_colors account_secondary_colors")
      .left_joins(:account)
      .includes(photo_attachment: :blob)
      .includes(:invoices)
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .select("#{::Account.table_name}.primary_color account_primary_color")
      .select("#{::Account.table_name}.secondary_color account_secondary_color")
      .select("#{::Account.table_name}.primary_colors account_primary_colors")
      .select("#{::Account.table_name}.secondary_colors account_secondary_colors")
      .select("#{::Customer.table_name}.name customer_name")
      .select("#{::Customer.table_name}.cpf_cnpj customer_cpf_cnpj")
      .left_joins(:customer)
      .left_joins(:account)
      .includes(photo_attachment: :blob)
      .traceability
  }
  scope :autocomplete, lambda {
    select(:id, :name)
  }

  scope :by_account_id, ->(account_id) { where(account_id: account_id) }
  scope :by_cod_emp, ->(cod_emp) { where(cod_emp: cod_emp) }
  scope :by_name, lambda { |name|
    where("UNACCENT(#{table_name}.name) ILIKE :name",
          name: "%#{I18n.transliterate(name)}%")
  }
  scope :by_email, ->(email) { where("UNACCENT(#{table_name}.email) ILIKE UNACCENT(:email)", email: "%#{email}%") }
  scope :administrators, -> { where(is_admin: true) }
  scope :account_administrator, -> { where(is_account_admin: true) }
  scope :by_phone_extension, lambda { |phone_extension|
    where("UNACCENT(#{table_name}.phone_extension) ILIKE :phone_extension",
          phone_extension: "%#{I18n.transliterate(phone_extension)}%")
  }
  scope :by_birthday, lambda { |start_birthday, end_birthday = nil|
    return if start_birthday.nil?

    start_date = Date.parse(start_birthday.to_s)
    end_date = end_birthday ? Date.parse(end_birthday.to_s) : start_date

    dates = (start_date..end_date).map do |date|
      "#{date.day}/#{date.month}"
    end

    where("EXTRACT(DAY FROM #{table_name}.birthday) || '/' || EXTRACT(MONTH FROM #{table_name}.birthday) "\
          "IN (:dates) AND #{table_name}.dont_show_birthday IS FALSE",
          dates: dates)
  }

  scope :with_complementary_changes, lambda {
    where(changed_complementary_info: true)
  }

  # Callbacks
  before_validation :set_provider,
                    :set_uid

  after_create :send_welcome_mail

  # Validations
  validates_presence_of :email, {
    if: :email_required?,
    message: :need_email
  }
  validates_uniqueness_of :email,
                          allow_blank: true,
                          conditions: -> { where(active: true, deleted_at: nil) }
  validates_format_of :email,
                      with: /\A[^@\s]+@[^@\s]+\z/,
                      allow_blank: true,
                      if: :email_changed?
  validates_uniqueness_of :uid,
                          scope: :provider,
                          conditions: -> { where(active: true, deleted_at: nil) }
  validates_presence_of :cpf, {
    if: :cpf_required?,
    message: :need_cpf
  }
  validates_uniqueness_of :cpf, allow_blank: true, if: :cpf_changed?

  # validates_presence_of :password, if: :password_required?
  # validates_length_of :password, within: 6..128, allow_blank: true
  validates_confirmation_of :password, if: :password_required?
  validates_format_of :password,
                      with: /(?=.*[a-z])(?=.*[A-Z])/,
                      message: :invalid_case_format,
                      if: -> { password.present? }
  validates_format_of :password,
                      with: /(?=.*[0-9])/,
                      message: :invalid_number_format,
                      if: -> { password.present? }
  validates_format_of :password,
                      with: /(?=.*[^A-Za-z0-9])/,
                      message: :invalid_special_character,
                      if: -> { password.present? }

  validates_presence_of :account_id, unless: -> { administrator? }
  validates_uniqueness_of :uuid
  validates :name, presence: true, length: { maximum: 255 }

  validate :administrator_restriction

  def send_welcome_mail
    return unless is_new_user

    params = { redirect_url: "#{account.base_url}/alterar-senha", config_name: 'default' }
    @client_config = params[:config_name]

    @redirect_url = params.fetch(
      :redirect_url,
      DeviseTokenAuth.default_password_reset_url
    )

    ActionMailer::Base.default_url_options[:host] = account.api_base_url

    send_reset_password_instructions(
      email: email,
      provider: 'email',
      redirect_url: @redirect_url,
      authkey: AUTH_KEY,
      client_config: params[:config_name],
      welcome_mail: true
    )
  end

  def create_log(description: nil)
    user_logs.create(
      {
        description: description,
        account_id: account_id,
        customer_id: customer_id,
        date: Time.now
      }
    )
  end

  def administrator?
    is_admin
  end

  def account_administrator?
    is_account_admin
  end

  def customer_ids
    (::Contact.by_cpf(cpf).pluck(:customer_id) + [customer_id]).compact
  end

  def customer?
    customer_ids.any?
  end

  def administrator_restriction
    return unless administrator? && account_id

    errors.add(:base, :cant_have_account)
  end

  def user?
    !administrator? && !account_administrator?
  end

  def keep_current_token(current_token)
    tokens.keep_if { |key| key == current_token }
    save!
  end

  def remove_all_tokens
    update_columns(tokens: {})
  end

  protected

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  class << self
    def format_date(day)
      date = Date.parse("#{day}/#{Date.today.year}")

      if date == Date.today
        "Hoje (#{day})"
      elsif (date.day - Date.today.day) == -1
        "Ontem (#{day})"
      else
        "#{I18n.t('date.day_names')[date.wday]} (#{day})"
      end
    end
  end

  def email_required?
    cpf.blank?
  end

  def cpf_required?
    email.blank?
  end

  private

  def set_provider
    self.provider = if email_without_cpf?
                      'email'
                    else
                      'cpf'
                    end
  end

  def set_uid
    self.uid = if cpf_without_email?
                 cpf
               else
                 email
               end
  end

  def cpf_without_email?
    cpf.present? && email.blank?
  end

  def email_without_cpf?
    email.present? && cpf.blank?
  end
end
