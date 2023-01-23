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
  has_enumeration_for :ethnicity, with: ::UserEthnicityEnum, create_helpers: true
  has_enumeration_for :sex, with: ::SexEnum, create_helpers: true

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :users, foreign_key: :account_id, optional: true
  belongs_to :department, -> { activated }, class_name: '::Department', inverse_of: :users, foreign_key: :department_id, optional: true
  belongs_to :headquarter, -> { activated }, class_name: '::Headquarter', inverse_of: :users, foreign_key: :headquarter_id, optional: true
  belongs_to :integration, -> { activated }, class_name: '::Integration', inverse_of: :users, foreign_key: :integration_id, optional: true
  belongs_to :shift, -> { activated }, class_name: '::Shift', inverse_of: :users, foreign_key: :shift_id, optional: true
  belongs_to :city, -> { activated }, class_name: '::Region::City', inverse_of: :users, foreign_key: :city_id, optional: true
  belongs_to :district, -> { activated }, class_name: '::Region::District', inverse_of: :users, foreign_key: :district_id, optional: true
  belongs_to :state, -> { activated }, class_name: '::Region::State', inverse_of: :users, foreign_key: :state_id, optional: true
  belongs_to :job_title, -> { activated }, class_name: '::JobTitle', inverse_of: :users, foreign_key: :job_title_id, optional: true
  belongs_to :manager, class_name: '::User', foreign_key: :manager_id, optional: true

  # Has_many associations
  has_many :access_logs, class_name: '::AccessLog', inverse_of: :created_by, foreign_key: :created_by_id
  has_many :action_by_messages, class_name: 'Chat::Rooms::Message', inverse_of: :action_by, foreign_key: :action_by_id
  has_many :action_in_messages, class_name: 'Chat::Rooms::Message', inverse_of: :action_in, foreign_key: :action_in_id
  has_many :attendances, class_name: '::Attendance', inverse_of: :responsible, foreign_key: :responsible_id
  has_many :calendars, class_name: '::Calendar', inverse_of: :user, foreign_key: :user_id, dependent: :destroy
  has_many :car_pools, class_name: 'CarPool', inverse_of: :user, foreign_key: :user_id
  has_many :car_reservations, class_name: '::Reservations::CarReservation', inverse_of: :user, foreign_key: :user_id
  has_many :check_in_by_visits, class_name: '::Visit', inverse_of: :check_in_by, foreign_key: :check_in_by_id
  has_many :check_out_by_visits, class_name: '::Visit', inverse_of: :check_out_by, foreign_key: :check_out_by_id
  has_many :chat_rooms, class_name: 'Chat::Room', inverse_of: :user, foreign_key: :user_id
  has_many :comments, class_name: '::Comment', inverse_of: :user, foreign_key: :user_id
  has_many :contract_users, class_name: '::Many::ContractUser', inverse_of: :user, foreign_key: :user_id, dependent: :destroy
  has_many :emergency_contacts, class_name: '::EmergencyContact', inverse_of: :user, foreign_key: :user_id
  has_many :employee_journeys, class_name: '::EmployeeJourney', inverse_of: :user, foreign_key: :user_id, dependent: :destroy
  has_many :equipment_users, class_name: '::Many::EquipmentUser', inverse_of: :user, foreign_key: :user_id, dependent: :destroy
  has_many :event_registrations, class_name: '::EventRegistration', inverse_of: :user, foreign_key: :user_id, dependent: :destroy
  has_many :license_plates, class_name: '::LicensePlate', inverse_of: :user, foreign_key: :user_id
  has_many :likes, class_name: '::Like', inverse_of: :user, foreign_key: :user_id
  has_many :local_reservations, class_name: '::Reservations::LocalReservation', inverse_of: :user, foreign_key: :user_id
  has_many :meeting_users, class_name: 'Many::MeetingUser', inverse_of: :user, foreign_key: :user_id
  has_many :notifications, class_name: '::Notification', inverse_of: :user, foreign_key: :user_id
  has_many :notification_tokens, class_name: '::NotificationToken', inverse_of: :user, foreign_key: :user_id
  has_many :solicitations, class_name: '::Solicitation', inverse_of: :user, foreign_key: :user_id
  has_many :poll_users, class_name: 'Many::PollUser', inverse_of: :user, foreign_key: :user_id
  has_many :participants, class_name: 'Chat::Rooms::Participant', inverse_of: :user, foreign_key: :user_id
  has_many :message_participants, class_name: 'Chat::Rooms::MessageParticipant', inverse_of: :user, foreign_key: :user_id
  has_many :message_submission_users, class_name: '::Many::MessageSubmissionUser', inverse_of: :user, foreign_key: :user_id, dependent: :destroy
  has_many :scholarship_users, class_name: '::ScholarshipUser', inverse_of: :user, foreign_key: :user_id, dependent: :destroy
  has_many :scholarship_user_proofs, class_name: '::ScholarshipUserProof', inverse_of: :user, foreign_key: :user_id, dependent: :destroy
  has_many :survey_ask_answers, class_name: '::SurveyAskAnswer', inverse_of: :user, foreign_key: :user_id, dependent: :destroy
  has_many :table_reservations, class_name: '::Reservations::TableReservation', inverse_of: :user, foreign_key: :user_id
  has_many :user_timeline, class_name: 'UserTimeline', inverse_of: :user, foreign_key: :user_id
  has_many :unimed_items, class_name: 'Many::UnimedItem', inverse_of: :user, foreign_key: :user_id
  has_many :unimed_users, class_name: 'Many::UnimedUser', inverse_of: :user, foreign_key: :user_id
  has_many :uniodonto_items, class_name: 'Many::UniodontoItem', inverse_of: :user, foreign_key: :user_id
  has_many :uniodonto_users, class_name: 'Many::UniodontoUser', inverse_of: :user, foreign_key: :user_id
  has_many :visit_users, class_name: 'Many::VisitUser', inverse_of: :user, foreign_key: :user_id
  has_many :managers_team, class_name: 'User', inverse_of: :manager, foreign_key: :manager_id

  # Many-to-many associations
  has_many :attendance_category_users, class_name: '::Many::AttendanceCategoryUser', inverse_of: :user, foreign_key: :user_id, dependent: :destroy
  has_many :user_groups, class_name: 'Many::UserGroup', inverse_of: :user, foreign_key: :user_id, dependent: :destroy
  has_many :activated_user_groups, -> { activated }, class_name: 'Many::UserGroup', inverse_of: :activated_user, foreign_key: :user_id, dependent: :destroy
  has_many :user_use_terms, class_name: 'Many::UserUseTerm', inverse_of: :user, foreign_key: :user_id
  has_many :user_useful_websites, -> { activated }, class_name: '::Many::UserUsefulWebsite', inverse_of: :user, foreign_key: :user_id, dependent: :destroy

  # Has-one through
  has_one :account_menu_background, through: :account, source: :menu_background_attachment
  has_one :account_toolbar_background, through: :account, source: :toolbar_background_attachment
  has_one :account_logo, through: :account, source: :logo_attachment
  has_one :headquarter_logo, through: :headquarter, source: :logo_attachment

  # Has-many through
  has_many :groups, through: :activated_user_groups
  has_many :employee_journey_records, through: :employee_journeys, source: :employee_journey_records
  has_many :group_permissions, through: :groups
  has_many :permissions, through: :group_permissions
  has_many :use_terms, through: :user_use_terms
  has_many :account_tools, through: :account
  has_many :equipment_registrations, through: :equipment_users, source: :equipment_registration

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{::Headquarter.table_name}.name headquarter_name")
      .select("#{::Headquarter.table_name}.primary_color headquarter_primary_color")
      .select("#{::Headquarter.table_name}.secondary_color headquarter_secondary_color")
      .select("#{::Headquarter.table_name}.primary_colors headquarter_primary_colors")
      .select("#{::Headquarter.table_name}.secondary_colors headquarter_secondary_colors")
      .select("#{::Department.table_name}.name department_name")
      .user_joins
      .includes(photo_attachment: :blob)
      .includes(background_profile_image_attachment: :blob)
      .includes(:user_use_terms)
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .select("#{::Headquarter.table_name}.name headquarter_name")
      .select("#{::Headquarter.table_name}.primary_color headquarter_primary_color")
      .select("#{::Headquarter.table_name}.secondary_color headquarter_secondary_color")
      .select("#{::Headquarter.table_name}.primary_colors headquarter_primary_colors")
      .select("#{::Headquarter.table_name}.secondary_colors headquarter_secondary_colors")
      .select("#{::Account.table_name}.layout_space_bar account_layout_space_bar")
      .select("#{::Account.table_name}.is_active_directory account_is_active_directory")
      .select("#{::Account.table_name}.project_name account_project_name")
      .select("#{::Account.table_name}.blocked_chat account_blocked_chat")
      .select("#{::Account.table_name}.blocked_chat_message account_blocked_chat_message")
      .select("#{::Account.table_name}.user_can_reset_pin account_user_can_reset_pin")
      .select("#{::Account.table_name}.active_directory_can_change_password account_active_directory_can_change_password")
      .select("#{::Account.table_name}.active_directory_password_recover_url account_active_directory_password_recover_url")
      .select("#{::Account.table_name}.active_directory_password_change_url account_active_directory_password_change_url")
      .select("#{::Account.table_name}.active_directory_password_change_guide account_active_directory_password_change_guide")
      .select("#{::Department.table_name}.name department_name")
      .select("#{::Shift.table_name}.name shift_name")
      .select("#{::JobTitle.table_name}.name job_title_name")
      .select("#{::Region::State.table_name}.uf state_uf")
      .select("#{::Region::City.table_name}.name city_name")
      .select("#{::Region::District.table_name}.name district_name")
      .select("(SELECT manager.name FROM #{table_name} manager WHERE manager.id = #{table_name}.manager_id) as manager_name")
      .left_joins(:account, :headquarter, :department, :shift, :job_title, :state, :city, :district, :contract_users)
      .includes(photo_attachment: :blob)
      .includes(background_profile_image_attachment: :blob)
      .includes(driver_license_photo_attachment: :blob)
      .includes(account_menu_background: :blob)
      .includes(account_toolbar_background: :blob)
      .includes(account_logo: :blob)
      .includes(headquarter_logo: :blob)
      .includes(:user_use_terms, :group_permissions, :permissions)
      .traceability
  }
  scope :profile, lambda {
    select("#{table_name}.*")
      .select("#{::Headquarter.table_name}.name headquarter_name")
      .select("#{::Department.table_name}.name department_name")
      .select("#{::Shift.table_name}.name shift_name")
      .select("#{::JobTitle.table_name}.name job_title_name")
      .select("(SELECT manager.name FROM #{table_name} manager WHERE manager.id = #{table_name}.manager_id) as manager_name")
      .left_joins(:account, :headquarter, :department, :shift, :job_title, :manager)
      .includes(photo_attachment: :blob)
      .includes(background_profile_image_attachment: :blob)
      .select("(SELECT managers.name FROM #{table_name} managers WHERE managers.id = #{table_name}.manager_id) as manager_name")
  }
  scope :autocomplete, lambda {
    select(:id, :name, :driver_license, :driver_license_category, :driver_license_expiration_date)
      .user_joins
  }
  scope :user_joins, lambda {
    joins(:account,
          :headquarter)
      .left_joins(:department)
  }
  scope :birthdays, lambda { |initial_date, final_date|
    select("#{table_name}.*")
      .select("to_char(#{table_name}.birthday, 'DD/MM') as birthday_and_month")
      .select("to_char(#{table_name}.admission_date, 'DD/MM') as company_birthday_and_month")
      .select("#{::Department.table_name}.name department_name")
      .select("#{::Department.table_name}.id department_id")
      .select("#{::Headquarter.table_name}.name headquarter_name")
      .left_outer_joins(:department)
      .joins(:headquarter)
      .by_birthday(initial_date, final_date)
      .where(dont_show_birthday: false)
      .includes(photo_attachment: :blob)
      .includes(background_profile_image_attachment: :blob)
      .where.not(birthday: nil)
      .active(true)
  }
  scope :order_by_birthday, lambda { |direction|
    order("birthday_and_month #{direction}")
  }
  scope :company_birthdays, lambda { |initial_date, final_date|
    select("#{table_name}.*")
      .select("to_char(#{table_name}.admission_date, 'DD/MM') as company_birthday_and_month")
      .select("#{::Department.table_name}.name department_name")
      .select("#{::Department.table_name}.id department_id")
      .select("#{::Headquarter.table_name}.name headquarter_name")
      .left_outer_joins(:department)
      .joins(:headquarter)
      .by_company_birthday(initial_date, final_date)
      .includes(photo_attachment: :blob)
      .includes(background_profile_image_attachment: :blob)
      .where.not(admission_date: nil)
      .active(true)
  }
  scope :order_by_admission_date, lambda { |direction|
    order("company_birthday_and_month #{direction}")
  }

  scope :has_email, ->(has_email) { where.not(email: [nil, '']) if has_email }
  scope :has_ramal, ->(has_ramal) { where.not(phone_extension: [nil, '']) if has_ramal }

  scope :except_user_to_chat_room, lambda { |current_user_id: nil, chat_room_id: nil|
    where("NOT EXISTS(SELECT 1 FROM #{::Chat::Rooms::Participant.table_name} WHERE #{::Chat::Rooms::Participant.table_name}.user_id = #{table_name}.id"\
    " AND #{::Chat::Rooms::Participant.table_name}.chat_room_id = :chat_room_id AND #{::Chat::Rooms::Participant.table_name}.active = TRUE)", chat_room_id: chat_room_id)
      .where.not(id: current_user_id)
  }
  scope :by_account_id, ->(account_id) { where(account_id: account_id) }
  scope :by_cod_emp, ->(cod_emp) { where(cod_emp: cod_emp) }

  scope :by_group_id, lambda { |group_id|
    includes(:user_groups).where(user_groups: { group_id: group_id })
  }
  scope :by_department_name, lambda { |name|
    where("EXISTS(SELECT 1 FROM #{::Department.table_name} WHERE #{::Department.table_name}.name ILIKE :name AND "\
          "#{::Department.table_name}.id = #{table_name}.department_id)",
          name: "%#{I18n.transliterate(name.downcase)}%")
  }
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
  scope :by_phone_extension, lambda { |phone_extension|
    where("UNACCENT(#{table_name}.phone_extension) ILIKE :phone_extension",
          phone_extension: "%#{I18n.transliterate(phone_extension)}%")
  }
  scope :by_license_plate, lambda { |license_plate|
    where("EXISTS(SELECT 1 FROM #{::LicensePlate.table_name} WHERE #{::LicensePlate.table_name}.plate "\
          "ILIKE :license_plate AND #{::LicensePlate.table_name}.user_id = #{table_name}.id)",
          license_plate: "%#{I18n.transliterate(license_plate)}%")
  }
  scope :by_birthday, lambda { |start_birthday, end_birthday = nil|
    return if start_birthday.nil?

    start_date = Date.parse(start_birthday.to_s)
    end_date = end_birthday ? Date.parse(end_birthday.to_s) : start_date

    dates = (start_date..end_date).map do |date|
      date.strftime('%d/%m')
    end

    where("to_char(#{table_name}.birthday, 'DD/MM') IN (:dates)  AND #{table_name}.dont_show_birthday IS FALSE", dates: dates)
  }
  scope :by_company_birthday, lambda { |start_company_birthday, end_company_birthday = nil|
    return if start_company_birthday.nil?

    start_date = Date.parse(start_company_birthday.to_s)
    end_date = end_company_birthday ? Date.parse(end_company_birthday.to_s) : start_date

    dates = (start_date..end_date).map do |date|
      date.strftime('%d/%m')
    end

    where("to_char(#{table_name}.admission_date, 'DD/MM') IN (:dates)", dates: dates)
  }
  scope :by_department_id, ->(department_id) { where(department_id: department_id) }
  scope :by_headquarter_id, ->(headquarter_id) { where(headquarter_id: headquarter_id) }
  scope :with_cpf, lambda {
    where.not(cpf: ['', nil])
  }
  scope :with_identification_number, lambda {
    where.not(identification_number: nil)
  }
  scope :with_complementary_changes, lambda {
    where(changed_complementary_info: true)
  }
  scope :not_vote_in_poll, lambda { |poll_id|
    where("NOT EXISTS(SELECT 1 FROM #{Many::PollUser.table_name} WHERE #{Many::PollUser.table_name}.poll_id = :poll_id AND #{Many::PollUser.table_name}.user_id = #{table_name}.id)", poll_id: poll_id)
  }
  scope :not_answer_survey, lambda { |survey_id|
    where("NOT EXISTS(SELECT 1 FROM #{SurveyAskAnswer.table_name} WHERE #{SurveyAskAnswer.table_name}.survey_id = :survey_id AND #{SurveyAskAnswer.table_name}.user_id = #{table_name}.id)", survey_id: survey_id)
  }
  scope :answered_survey, lambda { |survey_id|
    where("EXISTS(SELECT 1 FROM #{SurveyAskAnswer.table_name} WHERE #{SurveyAskAnswer.table_name}.survey_id = :survey_id AND #{SurveyAskAnswer.table_name}.user_id = #{table_name}.id)", survey_id: survey_id)
  }
  scope :by_attendance_category_id, lambda { |attendance_category_id|
    where("EXISTS(SELECT 1 FROM #{::Many::AttendanceCategoryUser.table_name} category_users WHERE #{table_name}.id = category_users.user_id AND category_users.active = true AND category_users.attendance_category_id = :attendance_category_id)", attendance_category_id: attendance_category_id)
  }

  scope :by_force_user_vote_once_access, -> { where(force_user_vote_once_access: true) }

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
