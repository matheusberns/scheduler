# frozen_string_literal: true

class PriorityTypeEnum < EnumerateIt::Base
  associate_values(
    urgent: 1,
    average: 2,
    low: 3
  )

  sort_by :value
end
