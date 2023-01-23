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

  # Belongs_to associations

  # Has_many associations
  has_many :users, class_name: '::User', inverse_of: :account, foreign_key: :account_id, dependent: :destroy

  # Many-to-many associations

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
