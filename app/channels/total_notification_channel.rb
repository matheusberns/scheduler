# frozen_string_literal: true

class TotalNotificationChannel < ApplicationCable::Channel
  after_subscribe :send_total_notification

  def subscribed
    stream_from("TotalNotificationRoom-#{current_user.id}")
  end

  def send_total_notification
    ActionCable.server.broadcast("TotalNotificationRoom-#{current_user.id}", total_notification_object)
  end

  def total_notification_object
    @user_notifications = current_user.notifications.list.activated

    total_central = notifications_filtered(::NotificationOriginEnum::CENTRAL)
    total_chat = notifications_filtered(::NotificationOriginEnum::CHAT)
    total_attendance = notifications_filtered(::NotificationOriginEnum::ATTENDANCE)

    {
      central: total_central,
      chat: total_chat,
      attendance: total_attendance,
      subscribed: true
    }
  end

  def notifications_filtered(type)
    @user_notifications.filter { |notification| notification.notification_origin == type && !notification.read }.size
  end
end
