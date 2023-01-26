# frozen_string_literal: true

class InvoiceTypeEnum < EnumerateIt::Base
  associate_values(
    out: 1,
    input: 2
  )

  sort_by :value
end
