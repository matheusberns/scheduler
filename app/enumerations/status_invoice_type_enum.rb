# frozen_string_literal: true

class StatusInvoiceTypeEnum < EnumerateIt::Base
  associate_values(
    typed: 1,
    closed: 2,
    canceled: 3,
    document_issued: 4,
    awaiting_closing: 5
  )

  sort_by :value
end
