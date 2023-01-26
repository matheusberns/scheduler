# frozen_string_literal: true

class SituationItemsEnum < EnumerateIt::Base
  associate_values(
    available: 1,
    without_stock: 2,
    waiting: 3,
    blocked: 4
  )

  sort_by :value
end
