# frozen_string_literal: true

Api::Application.routes.draw do
  namespace :enumerations do
    resources :status_invoice_types, only: %i[index show]
    resources :invoice_types, only: %i[index show]
    resources :integration_types, only: %i[index show]
    resources :service_types, only: %i[index show]
    resources :service_subtypes, only: %i[index show]
    resources :service_status, only: %i[index show]
    resources :order_situations, only: %i[index show]
    resources :billing_status, only: %i[index show]
    resources :budget_status, only: %i[index show]
  end
end
