# frozen_string_literal: true

module Notifications
  class HoustonService
    require 'houston'

    def send
      open_connection

      notify
    end

    private

    def initialize(token, notification)
      @token = token
      @notification = notification
    end

    def open_connection
      if ENV['APN_ENV'] == 'production'
        uri = Houston::APPLE_PRODUCTION_GATEWAY_URI
        certificate = File.read(Rails.root.join('certs', 'ck.pem'))
      else
        uri = Houston::APPLE_DEVELOPMENT_GATEWAY_URI
        certificate = File.read(Rails.root.join('certs', 'ck_dev.pem'))
      end
      passphrase = 'V3l0w321'

      @connection = Houston::Connection.new(uri, certificate, passphrase)
      @connection.open
    end

    def notify
      notification = Houston::Notification.new(device: @token)
      notification.alert = @notification.title
      notification.sound = 'bingbong.aiff'
      notification.content_available = true
      notification.custom_data = custom_data

      @connection.write(notification.message)
      @connection.close
    end

    def custom_data
      {
        id: @notification.id,
        origin: @notification.notification_origin,
        type: @notification.notification_type,
        notifiable_id: @notification.notifiable_id,
        chat_room_id: @notification.notifiable.try(:chat_room_id),
        space_id: @notification.notifiable.try(:space_id),
        title: @notification.title,
        body: @notification.message
      }
    end
  end
end
