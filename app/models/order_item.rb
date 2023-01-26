# frozen_string_literal: true

class OrderItem < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations
  has_enumeration_for :situation_item, with: ::SituationItemsEnum, create_helpers: { prefix: true }, required: false

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :order_items, foreign_key: :account_id
  belongs_to :product, -> { activated }, class_name: '::Product', inverse_of: :order_items, foreign_key: :product_id
  belongs_to :product_derivation, -> { activated }, class_name: '::ProductDerivation', inverse_of: :order_items, foreign_key: :product_derivation_id, required: false
  belongs_to :order, -> { activated }, class_name: '::Order', inverse_of: :order_items, foreign_key: :order_id

  # Has_many associations

  # Many-to-many associations

  # Has-many through

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{::Product.table_name}.name product_name")
      .select("#{::Product.table_name}.code product_code")
      .select("#{::ProductDerivation.table_name}.code product_derivation_code")
      .left_outer_joins(:product, :product_derivation)
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .select("#{::Product.table_name}.name product_name")
      .select("#{::Product.table_name}.code product_code")
      .select("#{::ProductDerivation.table_name}.code product_derivation_code")
      .left_outer_joins(:product, :product_derivation)
      .traceability
  }

  # Callbacks

  # Validations
end
