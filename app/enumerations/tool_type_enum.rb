# frozen_string_literal: true

class ToolTypeEnum < EnumerateIt::Base
  associate_values(
    solicitations: 1
  )

  sort_by :value
end
