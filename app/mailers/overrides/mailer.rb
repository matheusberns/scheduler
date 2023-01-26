# frozen_string_literal: true

module Overrides
  class Mailer < Devise::Mailer
    # helper :application # gives access to all helpers defined within `application_helper`.
    include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
    default template_path: 'devise/mailer'

    def reset_password_instructions(record, token, opts = {})
      @token = token
      @resource = record
      @opts = opts
      @user = record
      @resource = record

      delivery_options = ApplicationMailer.account_delivery_options(record&.account)

      mail(
        subject: @opts[:welcome_mail] ? 'Email de boas vindas' : 'Recuperação de senha',
        to: record.email,
        from: delivery_options[:from],
        delivery_method_options: delivery_options
      )
    end
  end
end
