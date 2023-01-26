# frozen_string_literal: true

class BillingStatusEnum < EnumerateIt::Base
  associate_values(
    open: 1,
    late: 2,
    paid: 3,
    cancel: 4,
    open_late: 5
  )

  sort_by :value
end
