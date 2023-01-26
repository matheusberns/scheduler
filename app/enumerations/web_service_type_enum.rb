# frozen_string_literal: true

class WebServiceTypeEnum < EnumerateIt::Base
  associate_values(
    billet: 1,
    invoice: 2
  )

  sort_by :value
end
