# frozen_string_literal: true

class Account < ApplicationRecord
  attr_accessor :destroying, :config_account, :timeout_in_to_all_users, :logout_by_tab_closed_to_all_users

  # Concerns

  # Active storage
  has_one_attached :logo
  has_one_attached :menu_background
  has_one_attached :toolbar_background
  has_one_attached :active_directory_ca_file

  # Enumerations
  has_enumeration_for :layout_space_bar, with: ::LayoutSpaceBarEnum, create_helpers: true

  # Belongs_to associations

  # Has_many associations
  has_many :access_logs, class_name: '::AccessLog', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :contract_users, class_name: '::Many::ContractUser', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :contracts, class_name: '::Contract', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :employee_journeys, class_name: '::EmployeeJourney', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :employee_journey_records, class_name: '::EmployeeJourneyRecord', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :equipment_contracts, class_name: '::Many::EquipmentContract', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :equipment_registrations, class_name: '::EquipmentRegistration', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :equipment_users, class_name: '::Many::EquipmentUser', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :attendances, class_name: '::Attendance', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :attendance_answers, class_name: '::AttendanceAnswer', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :attendance_categories, class_name: '::AttendanceCategory', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :attendance_priorities, class_name: '::AttendancePriority', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :birthday_cards, class_name: '::BirthdayCard', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :company_birthday_cards, class_name: '::CompanyBirthdayCard', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :calendars, class_name: '::Calendar', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :car_reservations, class_name: '::Reservations::CarReservation', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :cars, class_name: '::Car', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :car_pools, class_name: 'CarPool', inverse_of: :user, foreign_key: :account_id, dependent: :destroy
  has_many :chat_rooms, class_name: 'Chat::Room', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :comments, class_name: '::Comment', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :contacts, class_name: '::Contact', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :content_tvs, class_name: '::ContentTv', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :corporate_tvs, class_name: '::CorporateTv', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :departments, class_name: '::Department', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :digital_magazines, class_name: '::DigitalMagazine', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :dynamic_documents, class_name: '::DynamicDocument', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :event_dynamic_forms, class_name: '::EventDynamicForm', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :event_groups, class_name: '::Many::EventGroup', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :event_registrations, class_name: '::EventRegistration', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :dishes, class_name: '::Dish', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :districts, class_name: '::Region::District', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :emergency_contacts, class_name: '::EmergencyContact', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :events, class_name: '::Event', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :groups, class_name: '::Group', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :group_permissions, class_name: '::Many::GroupPermission', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :headquarters, class_name: '::Headquarter', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :integrations, class_name: '::Integration', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :job_titles, class_name: '::JobTitle', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :license_plates, class_name: '::LicensePlate', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :likes, class_name: '::Like', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :local_reservations, class_name: '::Reservations::LocalReservation', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :locals, class_name: '::Local', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :meal_plans, class_name: '::MealPlan', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :meals, class_name: '::Meal', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :meal_ratings, class_name: '::MealRating', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :meetings, class_name: 'Reservations::Meeting', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :meeting_rooms, class_name: '::MeetingRoom', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :messages, class_name: 'Chat::Rooms::Message', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :message_participants, class_name: 'Chat::Rooms::MessageParticipant', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :notifications, class_name: '::Notification', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :notification_tokens, class_name: '::NotificationToken', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :participants, class_name: 'Chat::Rooms::Participant', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :post_groups, class_name: '::Many::PostGroup', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :posts, class_name: '::Post', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :polls, class_name: '::Poll', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :poll_options, class_name: '::PollOption', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :shifts, class_name: '::Shift', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :solicitations, class_name: '::Solicitation', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :scholarships, class_name: '::Scholarship', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :scholarship_proofs, class_name: '::ScholarshipProof', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :scholarship_user_dynamic_documents, class_name: '::Many::ScholarshipUserDynamicDocument', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :scholarship_user_proofs, class_name: '::ScholarshipUserProof', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :scholarship_users, class_name: '::ScholarshipUser', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :scholarship_user_transfers, class_name: '::ScholarshipUserTransfer', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :message_submissions, class_name: '::MessageSubmission', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :message_submission_groups, class_name: '::Many::MessageSubmissionGroup', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :message_submission_users, class_name: '::Many::MessageSubmissionUser', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :spaces, class_name: '::Space', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :surveys, class_name: '::Survey', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :survey_asks, class_name: '::SurveyAsk', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :survey_groups, class_name: '::Many::SurveyGroup', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :survey_ask_answers, class_name: '::SurveyAskAnswer', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :survey_ask_fields, class_name: '::SurveyAskField', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :survey_ask_options, class_name: '::SurveyAskOption', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :tables, class_name: '::Table', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :table_reservations, class_name: '::Reservations::TableReservation', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :unimeds, class_name: '::Unimed', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :uniodontos, class_name: '::Uniodonto', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :visiting_companies, class_name: 'Visits::VisitingCompany', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :visiting_persons, class_name: 'Visits::VisitingPerson', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :visits, class_name: '::Visit', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :visit_users, class_name: '::Many::VisitUser', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :visiting_person_visits, class_name: '::Many::VisitingPersonVisit', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :use_terms, class_name: '::UseTerm', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :useful_websites, class_name: '::UsefulWebsite', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :users, class_name: '::User', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :user_timeline, class_name: 'UserTimeline', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :web_services, class_name: '::WebService', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :web_service_reports, class_name: '::WebServiceReport', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :web_service_report_exceptions, class_name: '::WebServiceReportException', inverse_of: :account, foreign_key: :account_id, dependent: :destroy

  # Many-to-many associations
  has_many :account_tools, -> { activated }, class_name: 'Many::AccountTool', inverse_of: :account, foreign_key: :account_id, dependent: :destroy
  has_many :all_account_tools, class_name: 'Many::AccountTool', foreign_key: :account_id, dependent: :destroy

  # Has-many through
  has_many :tools, through: :account_tools
  has_many :space_tools, through: :spaces

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
  before_validation :find_config_account
  after_create :default_setup
  after_create_commit :set_logo_from_account
  after_save_commit :set_update_users

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates_uniqueness_of :uuid, conditions: -> { activated }
  validates_presence_of :base_url
  validates_numericality_of :timeout_in, only_integer: true, less_than_or_equal_to: 9999, allow_nil: true
  validates :smtp_user, :smtp_password, :smtp_host, :smtp_email,
            :imap_host, :imap_user, :imap_password, :active_directory_host,
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

  def destroy
    self.destroying = true
    super
  end

  def group_default_permissions(tool_id: nil, active: true)
    ::Permission.where(tool_id: tool_id).each do |permission|
      if active
        groups.by_group_type(::GroupTypeEnum::ADMIN).each do |group|
          new_permission = ::Many::GroupPermission.by_group_id(group.id).find_or_initialize_by({ permission_id: permission.id, account_id: id })
          new_permission.active = true
          new_permission.deleted_at = nil
          new_permission.save
        end
      else
        permission.permission_groups.by_group_id(group_ids).update_all(active: false, deleted_at: Time.now)
      end
    end
  end

  def send_mail(received_email: nil)
    return unless received_email.present?

    Mailer.test_send_email(account: self, received_email: received_email).deliver_later
  end

  private

  def find_config_account
    return if Rails.env.test?

    account_request = ::Accounts::AccountConsult.new(uuid: uuid).find
    return unless account_request[:success]

    self.config_account = account_request[:account]

    self.name = config_account[:social_reason]
    self.project_name = config_account.dig(:joinin_config, :project_name)
    self.base_url = config_account.dig(:joinin_config, :base_url_web)
    self.api_base_url = config_account.dig(:joinin_config, :base_url)
  end

  def check_uuid
    errors.add(:uuid, :invalid) unless config_account.present? || Rails.env.test?
  end

  def set_logo_from_account
    return unless config_account.present?
    return unless config_account.dig(:image, :url).present?

    full_url = ACCOUNTS_URL + config_account.dig(:image, :url)
    downloaded_image = URI.parse(full_url).open
    logo.attach(io: downloaded_image, filename: Time.now.iso8601.to_s)
  end

  def default_setup
    ::AccountDefaultSetupJob.perform_now(reload) unless Rails.env.test?
  end

  def set_update_users
    return if !timeout_in_to_all_users && !logout_by_tab_closed_to_all_users

    ::Users::ConfigByAccountJob.perform_now(account: self, timeout_in_to_all_users: timeout_in_to_all_users, logout_by_tab_closed_to_all_users: logout_by_tab_closed_to_all_users)
  end
end
