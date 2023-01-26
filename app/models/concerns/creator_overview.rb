# frozen_string_literal: true

module CreatorOverview
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  included do
    def creator_overview
      user_overview(created_by)
    end

    def self_overview
      user_overview(self)
    end
  end

  private

  def user_overview(user)
    return if user.nil?

    birthday_formatted = nil
    is_birthday = false

    birthday = user.birthday
    if birthday && !user.dont_show_birthday
      today = Date.today
      birthday_formatted = birthday.try(:strftime, '%d/%m')
      is_birthday = (birthday.day == today.day && birthday.month == today.month)
    end

    {
      id: user.id,
      name: user.name,
      email: user.email,
      is_birthday: is_birthday,
      birthday: birthday_formatted,
      phone: user.phone,
      cellphone: user.cellphone,
      phone_extension: user.phone_extension,
      admission_age: user.admission_age,
      photo: user.photo_dimensions
    }
  end
end
