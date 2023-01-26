# frozen_string_literal: true

class Transporter < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :transporters, foreign_key: :account_id

  # Has_many associations
  has_many :orders, class_name: '::Order', inverse_of: :transporter, foreign_key: :transporter_id, dependent: :destroy

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
  scope :autocomplete, lambda {
    select(:id, :code, :name)
  }

  # Callbacks

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :code, presence: true, length: { maximum: 255 }
  validates :cnpj, presence: true, length: { minimum: 14, maximum: 14 }
end
