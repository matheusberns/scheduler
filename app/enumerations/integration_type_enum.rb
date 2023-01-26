# frozen_string_literal: true

class IntegrationTypeEnum < EnumerateIt::Base
  associate_values(
    portal: 1,
    consult_client: 2,
    consult_invoice: 3,
    consult_billing: 4,
    consult_installment: 5,
    integrate_budget: 6,
    integrate_service: 7,
    integrate_user_log: 8
  )

  sort_by :value
end
