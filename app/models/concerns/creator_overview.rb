# frozen_string_literal: true

module CreatorOverview
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  included do
    def creator_overview
      user_overview(user: created_by)
    end

    def self_overview
      user_overview(user: self)
    end

    def user_relation_overview(user)
      user_overview(user: user)
    end

    def creator_full_overview
      user_full_overview(user: created_by)
    end

    def self_full_overview
      user_full_overview(user: self)
    end

    def user_full_relation_overview(user)
      user_full_overview(user: user)
    end
  end

  private

  def user_overview(user: nil)
    return if user.nil?

    user = user[:user] if user[:user].present?

    department = user.department_id? ? { id: user.department_id, name: user.department&.name } : nil

    headquarter = user.headquarter_id? ? { id: user.headquarter_id, name: user.headquarter&.name } : nil

    shift = user.shift_id? ? { id: user.shift_id, name: user.shift&.name } : nil

    birthday = user.dont_show_birthday? ? nil : user.birthday&.to_time&.iso8601

    is_birthday = user.dont_show_birthday? ? false : (birthday&.to_date&.day == Date.today.day && birthday&.to_date&.month == Date.today.month)

    manager = user.manager_id? ? { id: user.manager_id, name: user.manager&.name } : nil

    {
      id: user.id,
      name: user.name,
      headquarter: headquarter,
      department: department,
      shift: shift,
      manager: manager,
      admission_date: user.admission_date&.to_time&.iso8601,
      birthday: birthday,
      is_birthday: is_birthday,
      email: user.hide_email ? nil : user.email,
      phone_extension: user.phone_extension,
      on_vacation: user.on_vacation,
      photo: user.photo_dimensions,
      background_profile_image: user.file_dimensions(user.background_profile_image)
    }
  end

  def user_full_overview(user: nil)
    return if user.nil?

    user = user[:user] if user[:user].present?

    department = user.department_id.present? ? { id: user.department_id, name: user.department&.name } : nil

    headquarter = user.headquarter_id.present? ? { id: user.headquarter_id, name: user.headquarter&.name } : nil

    shift = user.shift_id.present? ? { id: user.shift_id, name: user.shift&.name } : nil

    birthday = user.dont_show_birthday? ? nil : user.birthday&.to_time&.iso8601

    is_birthday = user.dont_show_birthday? ? false : (birthday&.to_date&.day == Date.today.day && birthday&.to_date&.month == Date.today.month)

    manager = user.manager_id? ? { id: user.manager_id, name: user.manager&.name } : nil

    {
      id: user.id,
      name: user.name,
      headquarter: headquarter,
      department: department,
      shift: shift,
      manager: manager,
      admission_date: user.admission_date&.to_time&.iso8601,
      birthday: birthday,
      is_birthday: is_birthday,
      email: user.hide_email ? nil : user.email,
      phone_extension: user.phone_extension,
      occupation: user.occupation,
      identification_number: user.identification_number,
      on_vacation: user.on_vacation,
      photo: user.photo_dimensions,
      background_profile_image: user.file_dimensions(user.background_profile_image)
    }
  end
end
