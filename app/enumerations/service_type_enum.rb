# frozen_string_literal: true

class ServiceTypeEnum < EnumerateIt::Base
  associate_values(
    technical_question: 1,
    reclamation: 2,
    document_request: 3
  )

  sort_by :value
end
