# frozen_string_literal: true

class BudgetStatusEnum < EnumerateIt::Base
  associate_values(
    in_typing: 1,
    integrating: 2,
    integrated: 3
  )

  sort_by :value
end
