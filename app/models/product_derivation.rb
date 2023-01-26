# frozen_string_literal: true

class ProductDerivation < ApplicationRecord
  # Concerns
  include Age

  # Active storage

  # Enumerations

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :product_derivations, foreign_key: :account_id
  belongs_to :product, -> { activated }, class_name: '::Product', inverse_of: :product_derivations, foreign_key: :product_id

  # Has_many associations
  has_many :budget_items, -> { activated }, class_name: '::BudgetItem', inverse_of: :product_derivation, foreign_key: :product_derivation_id
  has_many :order_items, -> { activated }, class_name: '::OrderItem', inverse_of: :product_derivation, foreign_key: :product_derivation_id

  # Many-to-many associations

  # Has-many through

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{::Product.table_name}.code product_code")
      .joins(:product)
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .select("#{::Product.table_name}.code product_code")
      .joins(:product)
      .traceability
  }
  scope :by_code, ->(code) { where(code: code) }
  scope :by_product_id, ->(product_id) { where(product_id: product_id, active: true) }

  # Callbacks

  # Validations
end
