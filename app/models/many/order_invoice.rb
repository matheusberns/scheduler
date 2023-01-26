# frozen_string_literal: true

module Many
  class OrderInvoice < ApplicationRecord
    # Concerns

    # Active storage

    # Enumerations

    # Belongs_to associations
    belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :order_invoices, foreign_key: :account_id
    belongs_to :order, -> { activated }, class_name: '::Order', inverse_of: :order_invoices, foreign_key: :order_id
    belongs_to :invoice, -> { activated }, class_name: '::Invoice', inverse_of: :order_invoices, foreign_key: :invoice_id

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

    # Callbacks

    # Validations

    def active_directory?
      is_active_directory
    end
  end
end
