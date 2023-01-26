# frozen_string_literal: true

class Notification < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations
  has_enumeration_for :notification_type, with: ::NotificationTypeEnum
  has_enumeration_for :notification_origin, with: ::NotificationOriginEnum

  # Belongs associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :notifications, foreign_key: :account_id
  belongs_to :user, -> { activated }, class_name: '::User', inverse_of: :notifications, foreign_key: :user_id
  belongs_to :notifiable, -> { activated }, polymorphic: true, inverse_of: :notifications, optional: true

  # Has_many associations
  has_many :notification_tokens, -> { activated }, through: :user

  # Many-to-many associations

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{User.table_name}.name user_name")
      .joins(:account, :user)
      .includes(:notifiable)
  }
  scope :read, ->(read) { where(read: read) }
  scope :central_notifications, -> { where(notification_origin: ::NotificationOriginEnum::CENTRAL) }
  scope :by_title, lambda { |title|
    where("UNACCENT(#{table_name}.title) ILIKE :title", title: "%#{I18n.transliterate(title)}%")
  }
  scope :by_message, lambda { |title|
    where("UNACCENT(#{table_name}.title) ILIKE :title", title: "%#{I18n.transliterate(title)}%")
  }
  scope :by_search, lambda { |search|
    by_title(search).or by_message(search)
  }

  # Callbacks
  after_commit :send_notification, on: :create

  # Validations
  validates :title, :message, :notification_type, :notification_origin, presence: true

  def read_notification
    update(read: true)
    send_total_notification
  end

  private

  def send_notification
    notification_tokens.each do |notification_token|
      if notification_token.firebase?
        ::Notifications::FirebaseNotificationJob.perform_later(notification_token.token, reload)
      elsif notification_token.houston?
        ::Notifications::HoustonNotificationJob.perform_later(notification_token.token, reload)
      end
    end

    send_total_notification
  end

  def send_total_notification
    ActionCable.server.broadcast("TotalNotificationRoom-#{user.id}", total_notification_object)
  end

  def total_notification_object
    @user_notifications = user.notifications.list.activated

    total_central = notifications_filtered(::NotificationOriginEnum::CENTRAL)
    total_chat = notifications_filtered(::NotificationOriginEnum::CHAT)
    total_attendance = notifications_filtered(::NotificationOriginEnum::ATTENDANCE)

    {
      central: total_central,
      chat: total_chat,
      attendance: total_attendance
    }
  end

  def notifications_filtered(type)
    @user_notifications.filter { |notification| notification.notification_origin == type && !notification.read }.size
  end
end
