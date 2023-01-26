# frozen_string_literal: true

module Notifications
  class FirebaseService
    require 'httparty'
    include ::HTTParty

    def send
      self.class.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: {
          'Authorization' => FCM_AUTHORIZATION_KEY,
          'Content-Type' => 'application/json'
        },
        body: body_params.to_json,
        debug_output: $stdout
      )
    end

    private

    def initialize(token, notification)
      @token = token
      @notification = notification
    end

    def body_params
      {
        to: @token,
        content_available: true,
        priority: 'high',
        data: {
          id: @notification.id,
          origin: @notification.notification_origin,
          type: @notification.notification_type,
          notifiable_id: @notification.notifiable_id,
          chat_room_id: @notification.notifiable.try(:chat_room_id),
          space_id: @notification.notifiable.try(:space_id),
          title: @notification.title,
          body: @notification.message
        }
      }
    end
  end
end
