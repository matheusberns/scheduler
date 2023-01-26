# frozen_string_literal: true

module Age
  extend ActiveSupport::Concern

  included do
    def creation_age
      age(created_at)
    end

    def admission_age
      age(admission_date)
    end

    def updated_at_age
      age(updated_at)
    end
  end

  private

  def age(start_time, end_time = Time.now)
    return if start_time.nil?

    start_time = start_time.to_time
    end_time = end_time.to_time

    custom_age(start_time, end_time)
  end

  def custom_age(start_time, end_time)
    time_difference = ::TimeDifference.between(start_time, end_time).in_general

    component, time = time_difference.filter { |_key, value| value.positive? }.first

    custom_message(component, time, start_time)
  end

  def custom_message(component, time, date)
    return 'Há poucos momentos' if time.nil?

    messages = {
      years: normalize_time(date),
      months: normalize_time(date),
      weeks: normalize_time(date),
      days: "#{time} dia" + pluralized(time),
      hours: "#{time} hora" + pluralized(time),
      minutes: "#{time} minuto" + pluralized(time),
      seconds: 'Há poucos momentos'
    }

    messages[component]
  end

  def full_age(start_time, end_time)
    time_difference = ::TimeDifference.between(start_time, end_time).in_general

    time_difference
      .filter { |_component, time| time.positive? }
      .map { |component, time| full_message(component, time.to_i) }
      .join(', ')
      .gsub(/,(?=[^,]*$)/, ' e')
  end

  def full_message(component, time)
    messages = {
      years: "#{time} ano" + pluralized(time),
      months: "#{time} " + month_pluralized(time),
      weeks: "#{time} semana" + pluralized(time),
      days: "#{time} dia" + pluralized(time),
      hours: "#{time} hora" + pluralized(time),
      minutes: "#{time} minuto" + pluralized(time),
      seconds: "#{time} segundo" + pluralized(time)
    }

    messages[component]
  end

  def pluralized(time)
    time > 1 ? 's' : ''
  end

  def month_pluralized(time)
    time > 1 ? 'meses' : 'mês'
  end

  def normalize_time(date)
    ::I18n.l(date, format: :normal)
  end
end
