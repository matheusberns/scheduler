# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable, :omniauthable, :confirmable, :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable

  include DeviseTokenAuth::Concerns::User

  # Accessors
  attr_accessor :update_to_integration, :current_solicitation_password

  # Concerns

  # Active storage
  has_one_attached :photo
  has_one_attached :background_profile_image
  has_one_attached :driver_license_photo

  # Enumerations

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :users, foreign_key: :account_id, optional: true

  # Has_many associations

  # Many-to-many associations

  # Has-one through

  # Has-many through

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .traceability
  }
  scope :profile, lambda {
    select("#{table_name}.*")
  }
  scope :autocomplete, lambda {
    select(:id, :name)
  }

  scope :birthdays, lambda { |initial_date, final_date|
    select("#{table_name}.*")
      .by_birthday(initial_date, final_date)
      .active(true)
  }
  scope :by_account_id, ->(account_id) { where(account_id: account_id) }
  scope :by_cod_emp, ->(cod_emp) { where(cod_emp: cod_emp) }

  scope :by_search, lambda { |search|
    by_name(search).or by_email(search).or by_phone_extension(search).or by_department_name(search).or by_identification_number(search).or by_cpf(search)
  }
  scope :by_name, lambda { |name|
    where("UNACCENT(#{table_name}.name) ILIKE :name",
          name: "%#{I18n.transliterate(name)}%")
  }
  scope :by_cpf, lambda { |cpf|
    where("UNACCENT(#{table_name}.cpf) ILIKE :cpf",
          cpf: "%#{I18n.transliterate(cpf)}%")
  }
  scope :by_email, ->(email) { where("UNACCENT(#{table_name}.email) ILIKE UNACCENT(:email)", email: "%#{email}%") }
  scope :by_identification_number, ->(identification_number) { where(identification_number: identification_number) }
  scope :administrators, -> { where(is_admin: true) }
  scope :account_administrator, -> { where(is_account_admin: true) }
  scope :not_administrators, -> { where(is_admin: false) }
  scope :not_current_user, ->(current_user_id) { where.not(id: current_user_id) }
  scope :not_account_administrator, -> { where.not(is_account_admin: true) }

  # Callbacks
  before_validation :set_provider,
                    :set_uid
  before_validation :format_cpf,
                    :format_rg,
                    :format_driver_license,
                    :format_phone,
                    :format_cellphone
  before_create :verify_force_change_password
  before_save :check_boolen_force_change_password
  before_save :verify_complementary_info
  after_create :associate_use_terms
  after_create :associate_default_groups
  after_save :associate_account_group, :associate_headquarter_group, :associate_department_group

  # Validations
  validates_presence_of :email, {
    if: :email_required?,
    message: :need_email_or_cpf
  }
  validates_uniqueness_of :email,
                          allow_blank: true,
                          conditions: -> { where(active: true, deleted_at: nil) }
  validates_format_of :email,
                      with: /\A[^@\s]+@[^@\s]+\z/,
                      allow_blank: true,
                      if: :email_changed?

  validates_format_of :personal_email,
                      with: /\A[^@\s]+@[^@\s]+\z/,
                      allow_blank: true,
                      if: :personal_email_changed?

  validates_uniqueness_of :uid,
                          scope: :provider,
                          conditions: -> { where(active: true, deleted_at: nil) }

  validates_presence_of :cpf, {
    if: :cpf_required?,
    message: :need_email_or_cpf
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

  validates_presence_of :account_id, unless: -> { administrator? || integrator? }
  validates_presence_of :headquarter_id, unless: -> { administrator? || integrator? }
  validates_presence_of :integration_id, if: -> { integrator? }
  validates_uniqueness_of :uuid
  validates :name, presence: true, length: { maximum: 255 }

  validate :cpf_valid
  validate :administrator_restriction

  def valid_solicitation_password(user_solicitation_password: nil)
    solicitation_password == user_solicitation_password
  end

  def integrator?
    is_integrator
  end

  def administrator?
    is_admin
  end

  def account_administrator?
    is_account_admin
  end

  def manager?
    managers_team.any?
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

  def active_directory?
    username.present?
  end

  def read_all_notifications
    notifications.activated.read(false).update_all(read: true)

    ::Chat::TotalNotificationRoomCableJob.perform_now(user: self)
  end

  def change_password(params)
    active_directory_login ? active_directory_change_password(params) : device_change_password(params)
  end

  def device_change_password(params)
    self.force_change_password = false
    self.password = params[:password]
    self.password_confirmation = params[:password_confirmation]
    save
  end

  def active_directory_change_password(params)
    return unless account.active_directory_can_change_password

    @active_directory = ::ActiveDirectory::Connection.new(username: username, password: params[:current_password], account: account, ssl: true)

    return if @active_directory.nil?

    @active_directory.resource

    @active_directory.authenticated? && @active_directory.persisted?

    if @active_directory.change_password(params[:password])
      errors.add(:base, :taken)
    else
      self.force_change_password = false
    end
  end

  protected

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def email_required?
    cpf.blank?
  end

  def cpf_required?
    email.blank?
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

  private

  def verify_force_change_password
    self.force_change_password = account.force_change_password if account.present?
  end

  def check_boolen_force_change_password
    self.force_change_password = false if force_change_password.nil?
  end

  def verify_complementary_info
    self.changed_complementary_info = true if complementary_fields_changed? && !update_to_integration
  end

  def complementary_fields_changed?
    zipcode_changed? ||
      state_id_changed? ||
      city_id_changed? ||
      district_id_changed? ||
      address_number_changed? ||
      address_complement_changed? ||
      driver_license_changed? ||
      address_changed? ||
      email_changed?
  end

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

  def associate_use_terms
    ::AssociateUseTermsJob.perform_now(new_user: reload)
  end

  def administrator_restriction
    return unless administrator? && (account_id || headquarter_id)

    errors.add(:base, :cant_have_account_or_headquarter)
  end

  def associate_default_groups
    associate_account_group account_id
    associate_headquarter_group headquarter_id
    associate_department_group department_id
  end

  def associate_account_group(account_id = nil)
    return unless saved_change_to_account_id? || account_id

    old_and_new = saved_change_to_account_id || [nil, account_id]

    update_groups_association(::GroupTypeEnum::ACCOUNT,
                              old_and_new,
                              ::Account)
  end

  def associate_headquarter_group(headquarter_id = nil)
    return unless saved_change_to_headquarter_id? || headquarter_id

    old_and_new = saved_change_to_headquarter_id || [nil, headquarter_id]

    update_groups_association(::GroupTypeEnum::HEADQUARTER,
                              old_and_new,
                              ::Headquarter)
  end

  def associate_department_group(department_id = nil)
    return unless saved_change_to_department_id? || department_id

    old_and_new = saved_change_to_department_id || [nil, department_id]

    update_groups_association(::GroupTypeEnum::DEPARTMENT,
                              old_and_new,
                              ::Department)
  end

  def update_groups_association(group_type, changes, group_origin)
    old_id = changes.first
    new_id = changes.last

    disassociate_from_old_group(old_id, group_type, group_origin) if old_id

    associate_to_new_group(new_id, group_type, group_origin) if new_id
  end

  def disassociate_from_old_group(old_id, group_type, group_origin)
    origin = group_origin.find_by(id: old_id)
    return if origin.nil?

    old_group = origin.groups.activated.find_by(group_type: group_type)
    return if old_group.nil?

    old_group.group_users.activated.where(user_id: id).destroy_all
  end

  def associate_to_new_group(new_id, group_type, group_origin)
    origin = group_origin.find_by(id: new_id)

    new_group = origin.groups.activated.find_by(group_type: group_type)

    return if new_group.nil?

    user_group = new_group.group_users.find_or_initialize_by(user_id: id)
    user_group.active = true
    user_group.deleted_at = nil
    user_group.skip_type_validation = true
    user_group.save
  end

  def format_driver_license
    driver_license&.remove!(/\W/)
  end

  def format_cpf
    cpf&.remove!(/\W/)
  end

  def format_rg
    rg&.remove!(/\W/)
  end

  def format_phone
    phone&.remove!(/\W/)
  end

  def format_cellphone
    cellphone&.remove!(/\W/)
  end

  def cpf_valid
    errors.add(:cpf, :invalid_format) unless ::CPF.new(cpf)&.valid? || Rails.env.test? || !cpf.present?
  end
end
