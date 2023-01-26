# frozen_string_literal: true

class ServiceSubtypeEnum < EnumerateIt::Base
  associate_values(
    commercial_attendance: 1,
    financial: 2,
    logistical: 3,
    product_quality: 4
  )

  sort_by :value
end
