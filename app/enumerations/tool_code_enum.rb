# frozen_string_literal: true

class ToolCodeEnum < EnumerateIt::Base
  associate_values(
    list_order: 1,
    pdf_order: 2,
    xls_order: 3,
    dashboard_chart_orders: 4,
    dashboard_chart_financials: 5,
    list_note: 6,
    danfe_note: 7,
    xml_note: 8,
    list_financial: 9,
    billet: 10,
    create_service: 11,
    budget: 12,
    news: 13
  )

  sort_by :value
end
