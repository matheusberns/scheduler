# frozen_string_literal: true

class BudgetItem < ApplicationRecord
  # Concerns
  include Age

  # Active storage

  # Enumerations

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :budget_items, foreign_key: :account_id
  belongs_to :customer, -> { activated }, class_name: '::Customer', inverse_of: :budget_items, foreign_key: :customer_id
  belongs_to :product_derivation, -> { activated }, class_name: '::ProductDerivation', inverse_of: :budget_items, foreign_key: :product_derivation_id, required: false
  belongs_to :product, -> { activated }, class_name: '::Product', inverse_of: :budget_items, foreign_key: :product_id
  belongs_to :budget, -> { activated }, class_name: '::Budget', inverse_of: :budget_items, foreign_key: :budget_id

  # Has_many associations

  # Many-to-many associations

  # Has-many through

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{::Budget.table_name}.purchase_order budget_purchase_order")
      .select("#{::ProductDerivation.table_name}.code product_derivation_code")
      .select("#{::Product.table_name}.name product_name")
      .select("#{::Product.table_name}.code product_code")
      .joins(:budget, :product_derivation, :product)
      .traceability
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .select("#{::Budget.table_name}.purchase_order budget_purchase_order")
      .select("#{::ProductDerivation.table_name}.code product_derivation_code")
      .select("#{::Product.table_name}.name product_name")
      .select("#{::Product.table_name}.code product_code")
      .joins(:budget, :product_derivation, :product)
      .traceability
  }
  scope :by_purchase_order, ->(purchase_order) { where(purchase_order: purchase_order) }
  scope :by_budget_item_number, ->(budget_item_number) { where(budget_item_number: budget_item_number) }
  scope :by_date, lambda { |start_date, end_date|
    start_date = Date.parse(start_date).strftime('%Y-%m-%d') if start_date
    end_date = Date.parse(end_date).strftime('%Y-%m-%d') if end_date

    if start_date && end_date
      where("#{table_name}.created_at >= :start_date and #{table_name}.created_at <= :end_date", start_date: start_date, end_date: end_date)
    elsif start_date
      where("#{table_name}.created_at >= :start_date", start_date: start_date)
    elsif end_date
      where("#{table_name}.created_at <= :end_date", end_date: end_date)
    end
  }
  scope :by_product_id, ->(product_id) { where(product_id: product_id) }
  scope :by_product_derivation_id, ->(product_derivation_id) { where(product_derivation_id: product_derivation_id) }

  # Callbacks

  # Validations
  validates_presence_of :quantity
  validate :multiply_quantity?, on: %i[create update]

  def multiply_quantity?
    product_derivation = ::ProductDerivation.select(:multiple_quantity).where(product_id: product_id, id: product_derivation_id).first

    errors.add(:base, I18n.t('.activerecord.errors.models.budget_items.attributes.base.multiple_quantity', example: (1..3).map { |x| (product_derivation.multiple_quantity * x).to_f }.join(', '))) if product_derivation.present? && (product_derivation.multiple_quantity.to_f > 1.0) && !(quantity.to_f % product_derivation.multiple_quantity.to_f).zero?
  end
end
