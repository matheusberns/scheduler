# frozen_string_literal: true

class ExternalService < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations
  has_enumeration_for :integration_type, with: ::IntegrationTypeEnum, create_helpers: { prefix: true }, required: false

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :customers, foreign_key: :account_id

  # Has_many associations

  # Many-to-many associations

  # Has-many through

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
  }
  scope :show, lambda {
    select("#{table_name}.*")
  }
  scope :autocomplete, lambda {
    select(:id, :code, :name)
  }
  scope :by_name, ->(name) { where("unaccent(#{table_name}.name) ILIKE :name", name: "%#{I18n.transliterate(name)}%") }

  # Callbacks

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
end
