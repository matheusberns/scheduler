# frozen_string_literal: true

class NotificationTypeEnum < EnumerateIt::Base
  associate_values(
    payroll: 1,
    employment_bond: 2,
    point_card: 3,
    point_mirror: 4,
    banked_hour: 5,
    vacation_balance: 6,
    vacation_warning: 7,
    vacation_receipt: 8,
    report_income: 9,
    profit_sharing: 10,
    christmas_bonus: 11,
    post: 12
  )

  sort_by :value
end
