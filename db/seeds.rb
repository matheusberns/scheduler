# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

::User.find_or_initialize_by(email: 'admin@sb.com.br').tap do |user|
  user.name = 'Administrador'
  user.password = '#Senha123'
  user.password_confirmation = '#Senha123'
  user.active = true
  user.deleted_at = nil
  user.is_admin = true
  user.save!
end

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

new_tool = ::Tool.find_or_initialize_by({ tool_code: ::ToolCodeEnum::LIST_FINANCIAL })
new_tool.name = 'Lista financeiros'
new_tool.slug = 'lista-de-financeiro'
new_tool.icon = 'money'
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