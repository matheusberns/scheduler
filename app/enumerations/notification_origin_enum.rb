# frozen_string_literal: true

class NotificationOriginEnum < EnumerateIt::Base
  associate_values(
    central: 1,
    chat: 2,
    attendance: 3
  )

  sort_by :value
end
