# frozen_string_literal: true

class ToolModuleTypeEnum < EnumerateIt::Base
  associate_values(
    order: 1,
    financial: 2,
    note: 3,
    service: 4,
    news: 5
  )

  sort_by :value
end
