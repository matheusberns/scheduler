# frozen_string_literal: true

class RatingTypeEnum < EnumerateIt::Base
  associate_values(
    product: 1,
    delivery: 2,
    attendance: 3
  )

  sort_by :value
end
