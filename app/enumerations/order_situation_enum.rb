# frozen_string_literal: true

class OrderSituationEnum < EnumerateIt::Base
  associate_values(
    in_analysis: 1,
    processing: 2,
    concluded: 3,
    refused: 4

  )

  sort_by :value
end
