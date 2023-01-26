# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def self.account_delivery_options(account)
    return if account.nil? || Rails.env.development? || Rails.env.test?

    {
      from: account.smtp_email,
      user_name: account.smtp_user,
      password: account.smtp_password,
      address: account.smtp_host,
      port: 587,
      authentication: :login,
      enable_starttls_auto: true,
      openssl_verify_mode: 'none'
    }
  end
end
