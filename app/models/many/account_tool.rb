# frozen_string_literal: true

class Many::AccountTool < ApplicationRecord
  self.table_name = 'account_tools'

  # Concerns

  # Active storage

  # Enumerations

  # Belongs associations

  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :account_tools, foreign_key: :account_id
  belongs_to :tool, -> { activated }, class_name: '::Tool', inverse_of: :tool_accounts, foreign_key: :tool_id

  # Has_many associations

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{::Tool.table_name}.name tool_name")
      .select("#{::Tool.table_name}.tool_code tool_code")
      .select("#{::Tool.table_name}.slug tool_slug")
      .select("#{::Tool.table_name}.icon tool_icon")
      .select("#{::Tool.table_name}.module_type tool_module_type")
      .joins(:tool, :account)
      .left_joins(:web_service_report)
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .select("#{::Tool.table_name}.name tool_name")
      .joins(:tool, :account)
      .left_joins(:web_service_report)
      .traceability
  }
  scope :autocomplete, lambda {
    select("#{table_name}.*")
      .select("#{::Tool.table_name}.name tool_name")
      .select("#{::Tool.table_name}.icon tool_icon")
      .joins(:tool, :account)
      .left_joins(:web_service_report)
  }
  scope :current_user, lambda { |user|
    where(account_id: user.account_id)
  }
  scope :by_search, lambda { |search|
    by_tool_name(search)
  }
  scope :by_tool_name, lambda { |name|
    where("UNACCENT(#{::Tool.table_name}.name) ILIKE :name", name: "%#{I18n.transliterate(name)}%")
  }
  scope :order_by_tool_name, lambda { |direction|
    order("#{::Tool.table_name}.name #{direction}")
  }
  scope :by_used_in, lambda { |used_in|
    joins(:tool)
      .where(tools: { used_in: used_in.to_s.split(',') })
  }
  scope :by_tool_code, ->(tool_code) { joins(:tool).where(tools: { tool_code: tool_code }) }

  # Callbacks

  # Validations
  validates_uniqueness_of :tool_id,
                          scope: :account_id,
                          conditions: -> { activated }
end
