# frozen_string_literal: true

class WebService < ApplicationRecord
  # Concerns

  # Active storage

  # Enumerations
  has_enumeration_for :web_service_type, with: ::WebServiceTypeEnum

  # Belongs_to associations
  belongs_to :account, -> { activated }, class_name: '::Account', inverse_of: :web_services, foreign_key: :account_id

  # Has_many associations
  has_many :reports, class_name: '::WebServiceReport', inverse_of: :web_service, foreign_key: :web_service_id,
                     dependent: :destroy

  # Scopes
  scope :list, lambda {
    joins(:account)
  }
  scope :show, lambda {
    select("#{table_name}.*")
      .joins(:account)
      .traceability
  }
  scope :autocomplete, lambda {
    select(:id, :web_service_type)
      .joins(:account)
  }
  scope :by_web_service_type, lambda { |web_service_type|
    where(web_service_type: web_service_type)
  }
  scope :by_web_service_type_name, lambda { |name|
    web_service_types = ::WebServiceTypeEnum.to_a
                                            .filter { |object| object[0]&.downcase&.include? name.to_s.downcase }
                                            .map { |object| object[1] }

    where(web_service_type: web_service_types)
  }
  scope :by_search, lambda { |search|
    by_web_service_type_name(search)
  }

  # Callbacks

  # Validations
  validates_uniqueness_of :web_service_type,
                          scope: :account_id,
                          conditions: -> { activated },
                          unless: :skip_on_test

  validates :web_service_type, presence: true
  validates :url_base, :wsdl, :user, :password, length: { maximum: 255 }, on: :update

  private

  def skip_on_test
    Rails.env.test?
  end
end
