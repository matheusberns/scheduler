# frozen_string_literal: true

class Region::District < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations

  # Belongs_to associations
  belongs_to :state, -> { activated }, class_name: '::Region::State', inverse_of: :districts, foreign_key: :state_id
  belongs_to :city, -> { activated }, class_name: '::Region::City', inverse_of: :districts, foreign_key: :city_id

  # Has_many associations
  has_many :users, class_name: '::User', inverse_of: :district, foreign_key: :district_id

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{::Region::State.table_name}.uf state_uf")
      .select("#{::Region::City.table_name}.name city_name")
      .joins(:state, :city)
  }
  scope :by_city_id, lambda { |city_id|
    where(city_id: city_id) if city_id.present?
  }
  scope :by_state_id, lambda { |state_id|
    where(state_id: state_id) if state_id.present?
  }

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
end
