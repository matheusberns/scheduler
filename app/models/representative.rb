# frozen_string_literal: true

class Representative < ApplicationRecord
  # Concerns
  include Age

  # Active storage

  # Enumerations

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :representatives, foreign_key: :account_id

  # Has_many associations
  has_many :customers, class_name: '::Customer', inverse_of: :representative, foreign_key: :representative_id

  # Many-to-many associations

  # Has-many through

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .traceability
  }
  scope :by_name, ->(name) { where("unaccent(#{table_name}.name) ILIKE :name", name: "%#{I18n.transliterate(name)}%") if name }
  scope :by_code, ->(code) { where("unaccent(#{table_name}.code) ILIKE :code", code: "%#{I18n.transliterate(code)}%") if code }

  # Callbacks

  # Validations
  validates_presence_of :name
  validates_presence_of :code
  validates_length_of :name, maximum: 255
  validates_length_of :code, maximum: 255
  validates_length_of :email, maximum: 255
end
