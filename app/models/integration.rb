# frozen_string_literal: true

class Integration < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations
  has_enumeration_for :integration_type, with: ::IntegrationTypeEnum

  # Belongs associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :integrations, foreign_key: :account_id

  # Has_many associations
  has_many :users, class_name: '::User', inverse_of: :integration, foreign_key: :integration_id, dependent: :destroy

  # Many-to-many associations

  # Scopes
  scope :list, lambda {
    select("#{table_name}.*")
      .joins(:account)
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .joins(:account)
  }
  scope :by_integration_type, ->(integration_type) { where(integration_type: integration_type) }
  scope :by_remote_ip, ->(remote_ip) { where("UNACCENT(#{table_name}.remote_ip) ILIKE :remote_ip", remote_ip: "%#{I18n.transliterate(remote_ip)}%") }
  scope :by_description, ->(description) { where("UNACCENT(#{table_name}.description) ILIKE :description", description: "%#{I18n.transliterate(description)}%") }

  # Callbacks

  # Validations
  validates :token,
            :integration_type,
            presence: true
end
