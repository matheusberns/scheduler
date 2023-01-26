# frozen_string_literal: true

class New < ApplicationRecord
  # Concerns
  include Age

  # Active storage
  has_one_attached :file

  # Enumerations

  # Belongs_to associations

  # Has_many associations

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
  scope :by_title, ->(title) { where("unaccent(#{table_name}.title) ILIKE :title", title: "%#{I18n.transliterate(title)}%") if title }

  # Callbacks

  # Validations
  validates_presence_of :title
  validates_length_of :title, maximum: 255
end
