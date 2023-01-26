# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

::User.find_or_initialize_by(email: 'admin@bp.com.br').tap do |user|
  user.name = 'Administrador'
  user.password = '#Senha123'
  user.password_confirmation = '#Senha123'
  user.active = true
  user.deleted_at = nil
  user.save!
end

::Integration.find_or_initialize_by(token: 'f4f49fd6deed76678e60').tap do |integration|
  integration.description = 'Rapt'
  integration.integration_type = IntegrationTypeEnum::PORTAL
  integration.account = Account.find_by(name: 'Volk do Brasil')
  integration.active = true
  integration.save
end

::Integration.find_or_initialize_by(token: 'f4f49fd6deed76678e60').tap do |integration|
  integration.description = 'TESC'
  integration.integration_type = IntegrationTypeEnum::PORTAL
  integration.account = Account.find_by(name: 'TESC')
  integration.active = true
  integration.save
end

new_tool = ::Tool.find_or_initialize_by({ tool_code: ::ToolCodeEnum::LIST_ORDER })
new_tool.name = 'Lista de pedidos'
new_tool.slug = 'lista-de-pedidos'
new_tool.icon = 'grading'
new_tool.active = true
new_tool.deleted_at = nil
new_tool.save

new_tool = ::Tool.find_or_initialize_by({ tool_code: ::ToolCodeEnum::PDF_ORDER })
new_tool.name = 'PDF do pedido'
new_tool.slug = 'pdf-do-pedido'
new_tool.icon = 'picture_as_pdf'
new_tool.active = true
new_tool.deleted_at = nil
new_tool.save

new_tool = ::Tool.find_or_initialize_by({ tool_code: ::ToolCodeEnum::XLS_ORDER })
new_tool.name = 'XLS do pedido'
new_tool.slug = 'xls-do-pedido'
new_tool.icon = 'code'
new_tool.active = true
new_tool.deleted_at = nil
new_tool.save

new_tool = ::Tool.find_or_initialize_by({ tool_code: ::ToolCodeEnum::DASHBOARD_CHART_ORDERS })
new_tool.name = 'Gráficos dashboard pedidos'
new_tool.slug = 'graficos-dashboard-pedidos'
new_tool.icon = 'show_chart'
new_tool.active = true
new_tool.deleted_at = nil
new_tool.save

new_tool = ::Tool.find_or_initialize_by({ tool_code: ::ToolCodeEnum::DASHBOARD_CHART_FINANCIALS })
new_tool.name = 'Gráficos dashboard financeiros'
new_tool.slug = 'graficos-dashboard-financeiros'
new_tool.icon = 'query_stats'
new_tool.active = true
new_tool.deleted_at = nil
new_tool.save

new_tool = ::Tool.find_or_initialize_by({ tool_code: ::ToolCodeEnum::LIST_NOTE })
new_tool.name = 'Lista de notas'
new_tool.slug = 'lista-de-notas'
new_tool.icon = 'notes'
new_tool.active = true
new_tool.deleted_at = nil
new_tool.save

new_tool = ::Tool.find_or_initialize_by({ tool_code: ::ToolCodeEnum::DANFE_NOTE })
new_tool.name = 'DANFE da nota'
new_tool.slug = 'danfe-da-nota'
new_tool.icon = 'description'
new_tool.active = true
new_tool.deleted_at = nil
new_tool.save

new_tool = ::Tool.find_or_initialize_by({ tool_code: ::ToolCodeEnum::XML_NOTE })
new_tool.name = 'XML da nota'
new_tool.slug = 'xml-da-nota'
new_tool.icon = 'document_scanner'
new_tool.active = true
new_tool.deleted_at = nil
new_tool.save

new_tool = ::Tool.find_or_initialize_by({ tool_code: ::ToolCodeEnum::LIST_FINANCIAL })
new_tool.name = 'Lista financeiros'
new_tool.slug = 'lista-de-financeiro'
new_tool.icon = 'money'
new_tool.active = true
new_tool.deleted_at = nil
new_tool.save

new_tool = ::Tool.find_or_initialize_by({ tool_code: ::ToolCodeEnum::BILLET })
new_tool.name = 'Boleto'
new_tool.slug = 'boleto'
new_tool.icon = 'payments'
new_tool.active = true
new_tool.deleted_at = nil
new_tool.save

new_tool = ::Tool.find_or_initialize_by({ tool_code: ::ToolCodeEnum::CREATE_SERVICE })
new_tool.name = 'Novo serviço'
new_tool.slug = 'novo-servico'
new_tool.icon = 'design_services'
new_tool.active = true
new_tool.deleted_at = nil
new_tool.save

new_tool = ::Tool.find_or_initialize_by({ tool_code: ::ToolCodeEnum::BUDGET })
new_tool.name = 'Orçamento'
new_tool.slug = 'orcamento'
new_tool.icon = 'price_change'
new_tool.active = true
new_tool.deleted_at = nil
new_tool.save

new_tool = ::Tool.find_or_initialize_by({ tool_code: ::ToolCodeEnum::NEWS })
new_tool.name = 'Novidades'
new_tool.slug = 'novidades'
new_tool.icon = 'maps_ugc'
new_tool.active = true
new_tool.deleted_at = nil
new_tool.save