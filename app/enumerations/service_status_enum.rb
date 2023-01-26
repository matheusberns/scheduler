# frozen_string_literal: true

class ServiceStatusEnum < EnumerateIt::Base
  associate_values(
    in_progress: 1,
    finished: 2
  )

  sort_by :value
end
