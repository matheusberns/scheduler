# frozen_string_literal: true

class Region::City < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations

  # Belongs_to associations
  belongs_to :state, -> { activated }, class_name: '::Region::State', inverse_of: :cities, foreign_key: :state_id

  # Has_many associations
  has_many :districts, class_name: '::Region::District', inverse_of: :city, foreign_key: :district_id
  has_many :users, class_name: '::User', inverse_of: :city, foreign_key: :city_id

  # Many-to-many associations

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{Region::State.table_name}.uf state_uf")
      .joins(:state)
  }
  scope :by_name, lambda { |name|
    where("UNACCENT(#{table_name}.name) ILIKE :name", name: "%#{I18n.transliterate(name)}%")
  }
  scope :by_search, ->(search) { by_name(search) }
  scope :by_state_id, ->(state_id) { where(state_id: state_id) }
  scope :by_id, ->(id) { where(id: id) }

  # Callbacks

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
end
