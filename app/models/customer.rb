# frozen_string_literal: true

class Customer < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :customers, foreign_key: :account_id
  belongs_to :representative, -> { activated }, class_name: '::Representative', inverse_of: :customers, foreign_key: :representative_id, required: false

  # Has_many associations
  has_many :orders, class_name: '::Order', inverse_of: :customer, foreign_key: :customer_id, dependent: :destroy
  has_many :users, class_name: '::User', inverse_of: :customer, foreign_key: :customer_id, dependent: :destroy
  has_many :invoices, class_name: '::Invoice', inverse_of: :customer, foreign_key: :customer_id, dependent: :destroy
  has_many :billings, class_name: '::Billing', inverse_of: :customer, foreign_key: :customer_id, dependent: :destroy
  has_many :services, class_name: '::Service', inverse_of: :customer, foreign_key: :customer_id, dependent: :destroy
  has_many :installments, class_name: '::Installment', inverse_of: :customer, foreign_key: :customer_id, dependent: :destroy
  has_many :order_ratings, class_name: '::OrderRating', inverse_of: :customer, foreign_key: :customer_id
  has_many :user_logs, class_name: '::UserLog', inverse_of: :customer, foreign_key: :customer_id
  has_many :budgets, class_name: '::Budget', inverse_of: :customer, foreign_key: :customer_id
  has_many :budget_items, class_name: '::BudgetItem', inverse_of: :customer, foreign_key: :customer_id
  has_many :contacts, class_name: '::Contact', inverse_of: :customer, foreign_key: :customer_id

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
    select("#{table_name}.*")
  }
  scope :by_cpf_cnpj, ->(cpf_cnpj) { where("unaccent(#{table_name}.cpf_cnpj) ILIKE '%#{cpf_cnpj.gsub(/\D/, '')}%'") if cpf_cnpj.present? }
  scope :by_name, ->(name) { where("unaccent(#{table_name}.name) ILIKE :name", name: "%#{I18n.transliterate(name)}%") }
  scope :by_id, -> (id) { where(id: id) }

  # Callbacks

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :code, presence: true, length: { maximum: 255 }
  validates :cpf_cnpj, presence: true, length: { maximum: 255 }
  validates :email, allow_blank: true, length: { maximum: 255 }
  validates_uniqueness_of :code, :cpf_cnpj, on: :create

  def create_user(email: nil, password: nil)
    user = users.find_or_initialize_by({ customer_id: id })

    user.is_new_user = email != user.email ? true : false
    user.account_id = account_id
    user.name = name
    user.email = email
    user.password_confirmation = password
    user.password = password
    user.active = true
    user.deleted_at = nil

    user.save
  end
end
