# frozen_string_literal: true

class Contact < ApplicationRecord
  # Concerns
  include Age

  # Active storage

  # Enumerations

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :contacts, foreign_key: :account_id
  belongs_to :customer, -> { activated }, class_name: '::Customer', inverse_of: :contacts, foreign_key: :customer_id

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
  scope :by_cpf, ->(cpf) { where("#{table_name}.cpf ILIKE :cpf", cpf: "%#{I18n.transliterate(cpf)}%") if cpf }

  # Callbacks

  # Validations
  validates_presence_of :cpf
end
