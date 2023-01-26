# frozen_string_literal: true

class WebServiceReport < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :web_service_reports, foreign_key: :account_id
  belongs_to :web_service, -> { activated }, class_name: '::WebService', inverse_of: :reports, foreign_key: :web_service_id

  # Has_many associations

  # Many-to-many associations

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .select("#{::WebService.table_name}.web_service_type web_service_type")
      .joins(:account, :web_service)
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .select("#{::WebService.table_name}.web_service_type web_service_type")
      .joins(:account, :web_service)
      .traceability
  }
  scope :autocomplete, lambda {
    select(:id, :code, :description)
      .select("#{::WebService.table_name}.web_service_type web_service_type")
      .joins(:account, :web_service)
  }
  scope :by_search, lambda { |search|
    by_code(search)
      .or(by_description(search))
      .or(by_code_with_description(search))
  }
  scope :by_code, lambda { |code|
    where("#{table_name}.code ILIKE :code", code: "%#{code}%")
  }
  scope :by_description, lambda { |description|
    where("#{table_name}.description ILIKE :description", description: "%#{description}%")
  }
  scope :by_code_with_description, lambda { |code_with_description|
    where("CONCAT(#{table_name}.description, ' - ', #{table_name}.code) "\
          'ILIKE :code_with_description',
          code_with_description: "%#{code_with_description}%")
  }
  scope :by_web_service_id, lambda { |web_service_id|
    where(web_service_id: web_service_id)
  }

  # Callbacks

  # Validations
  validates :code, presence: true, length: { maximum: 20 }
  validates :description, presence: true, length: { maximum: 255 }
  validates :input_variables, presence: true, length: { maximum: 2000 }
end
