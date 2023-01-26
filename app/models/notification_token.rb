# frozen_string_literal: true

class NotificationToken < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations
  has_enumeration_for :token_type, with: ::TokenTypeEnum

  # Belongs associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :notification_tokens, foreign_key: :account_id
  belongs_to :user, -> { activated }, class_name: '::User', inverse_of: :notification_tokens, foreign_key: :user_id

  # Has_many associations

  # Many-to-many associations

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .joins(:account, :user)
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .joins(:account, :user)
      .traceability
  }
  scope :by_user_id, lambda { |user_id|
    where(user_id: user_id)
  }

  # Callbacks

  # Validations
  validates :token, :token_type, presence: true
  validates_uniqueness_of :token,
                          conditions: -> { activated }

  def firebase?
    token_type == ::TokenTypeEnum::FIREBASE
  end

  def houston?
    token_type == ::TokenTypeEnum::HOUSTON
  end
end
