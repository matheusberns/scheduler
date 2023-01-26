# frozen_string_literal: true

class UserLog < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :user_logs, foreign_key: :account_id
  belongs_to :customer, -> { activated }, class_name: '::Customer', inverse_of: :user_logs, foreign_key: :customer_id
  belongs_to :user, -> { activated }, class_name: '::User', inverse_of: :user_logs, foreign_key: :user_id

  # Has_many associations

  # Many-to-many associations

  # Has-many through

  # Scopes

  # Callbacks

  # Validations
  validates :date, presence: true
  validates :description, presence: true, length: { maximum: 255 }
end
