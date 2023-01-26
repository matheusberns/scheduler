# frozen_string_literal: true

class PaymentCondition < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :payment_conditions, foreign_key: :account_id

  # Has_many associations
  has_many :orders, class_name: '::Order', inverse_of: :payment_condition, foreign_key: :payment_condition_id, dependent: :destroy

  # Many-to-many associations

  # Has-many through

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{::Account.table_name}.name account_name")
      .joins(:account)
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .select("#{::Account.table_name}.name account_name")
      .joins(:account)
      .traceability
  }
  scope :autocomplete, lambda {
    select(:id, :code, :name)
  }

  # Callbacks

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :code, presence: true, length: { maximum: 255 }
end
