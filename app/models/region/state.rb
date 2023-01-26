# frozen_string_literal: true

class Region::State < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations

  # Belongs_to associations

  # Has_many associations
  has_many :cities, class_name: 'Region::City', inverse_of: :state, foreign_key: :state_id
  has_many :districts, class_name: '::Region::District', inverse_of: :city, foreign_key: :district_id
  has_many :users, class_name: '::User', inverse_of: :state, foreign_key: :state_id

  # Many-to-many associations

  # Scopes
  scope :list, -> {}
  scope :by_uf, lambda { |uf|
    where("UNACCENT(#{table_name}.uf) ILIKE :uf", uf: "%#{I18n.transliterate(uf)}%")
  }
  scope :by_search, ->(search) { by_uf(search) }
  scope :by_id, ->(id) { where(id: id) }

  # Callbacks

  # Validations
  validates :uf, presence: true, length: { maximum: 255 }
end
