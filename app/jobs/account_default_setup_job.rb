# frozen_string_literal: true

class AccountDefaultSetupJob < ApplicationJob
  queue_as :account_setup_default_job

  def perform(account = nil)
    return if account.nil?

    create_admin account
  end

  def create_admin(account)
    first_name_capitalize = I18n.transliterate(account.name.split.first.capitalize)
    today_numbers = Date.today.strftime('%d%m%Y')

    password = "#{first_name_capitalize}@#{today_numbers}"
    admin_params = {
      name: 'Administrador',
      email: "admin@#{account.name.parameterize}.com.br",
      password: password,
      password_confirmation: password,
      is_account_admin: true,
      account_id: account.id
    }

    ::User.create!(admin_params)
  end
end
