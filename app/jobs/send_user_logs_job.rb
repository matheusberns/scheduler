# frozen_string_literal: true

class SendUserLogsJob < ApplicationJob
  queue_as :send_user_logs_job

  def self.scheduled(_queue, _klass, *_args)
    SendUserLogsJob.send_user_logs
  end

  def perform
    SendUserLogsJob.send_user_logs
  end

  def self.send_user_logs
    Integrations::UserLog.new.user_log(customers: Customer.all)
  end
end
