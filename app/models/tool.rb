# frozen_string_literal: true

class Tool < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations
  has_enumeration_for :module_type, with: ::ToolModuleTypeEnum, create_helpers: true
  has_enumeration_for :tool_type, with: ::ToolTypeEnum, create_helpers: true
  has_enumeration_for :tool_code, with: ::ToolCodeEnum, create_helpers: true

  # Belongs associations

  # Has_many associations

  # Many-to-many associations
  has_many :tool_accounts, -> { activated }, class_name: 'Many::AccountTool', inverse_of: :tool, foreign_key: :tool_id, dependent: :destroy

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .includes(:tool_accounts)
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .traceability
  }
  scope :autocomplete, lambda {
    select(:id, :name)
  }

  scope :by_name, ->(name) { where("UNACCENT(#{table_name}.name) ILIKE :name", name: "%#{I18n.transliterate(name)}%") }

  scope :by_module_type, ->(module_type) { where(module_type: module_type) }

  scope :by_search, ->(search) { by_name(search) }
  scope :by_tool_code, ->(tool_code) { where(tool_code: tool_code) }

  scope :current_user, lambda { |user|
    joins(:tool_accounts).where(tool_accounts: { account_id: user.account_id, active: true })
  }
  scope :order_by_module_type_name, lambda { |_direction|
    order('module_type asc, name asc')
  }

  # Callbacks

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates_uniqueness_of :tool_code, conditions: -> { activated }
end
