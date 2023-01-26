# frozen_string_literal: true

class TokenTypeEnum < EnumerateIt::Base
  associate_values(
    houston: 1,
    firebase: 2
  )

  sort_by :value
end
