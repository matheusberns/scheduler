# frozen_string_literal: true

class Budget < ApplicationRecord
  # Concerns
  include Age

  # Active storage

  # Enumerations
  has_enumeration_for :status, with: ::BudgetStatusEnum, create_helpers: { prefix: true }

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :budgets, foreign_key: :account_id
  belongs_to :customer, -> { activated }, class_name: '::Customer', inverse_of: :budgets, foreign_key: :customer_id

  # Has_many associations
  has_many :budget_items, -> { activated }, class_name: '::BudgetItem', inverse_of: :budget, foreign_key: :budget_id
  has_many :orders, -> { activated }, class_name: '::Order', inverse_of: :budget, foreign_key: :budget_id

  # Many-to-many associations

  # Has-many through

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{::Customer.table_name}.name customer_name")
      .select("(SELECT rp.name FROM #{::Representative.table_name} rp WHERE rp.id = #{::Customer.table_name}.representative_id LIMIT 1) as representative_name")
      .joins(:customer)
      .traceability
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .select("#{::Customer.table_name}.name customer_name")
      .select("(SELECT rp.name FROM #{::Representative.table_name} rp WHERE rp.id = #{::Customer.table_name}.representative_id LIMIT 1) as representative_name")
      .joins(:customer)
      .traceability
  }
  scope :by_purchase_order, ->(purchase_order) { where('budgets.purchase_order LIKE :purchase_order', purchase_order: "%#{purchase_order}%") }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_budget_number, ->(budget_number) { where(budget_number: budget_number) }
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

  # Callbacks
  before_create :set_sequence

  # Validations
  validates_presence_of :sequence
  validates_presence_of :purchase_order
  validates_uniqueness_of :sequence, scope: :customer_id

  def set_sequence
    sequence = customer.budgets.order(sequence: :asc).last&.sequence.to_i

    self.sequence = sequence.zero? ? 1 : sequence + 1
  end
end
