# frozen_string_literal: true

Rails.application.routes.draw do
  # Load others routes files
  draw(:account_admin)
  draw(:admin)
  draw(:current_user)
  draw(:enumeration)
  draw(:integration)

  # Regions
  resources :states, controller: 'regions/states', only: :index
  resources :cities, controller: 'regions/cities', only: :index

  # Cable
  mount ActionCable.server => '/cable'

  # Devise overrides
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    token_validations: 'overrides/token_validations',
    sessions: 'overrides/sessions',
    passwords: 'overrides/passwords'
  }

  scope module: :homepages do
    resources :customers, only: %i[index show], controller: 'customers'

    resources :billings, only: %i[index show], controller: 'billings'
    match 'billings/:id/generate_billet' => 'billings#generate_billet', via: :get
    match 'billings/:id/duplicate_billet' => 'billings#duplicate_billet', via: :get

    match 'budgets/:id/integrate' => 'budgets#integrate', via: %i[put patch]
    resources :budgets, except: %i[new edit], controller: 'budgets' do
      resources :budget_items, except: %i[new edit], controller: 'budgets/budget_items'
    end

    match 'dashboards/get_annual_orders' => 'dashboards#get_annual_orders', via: :get
    match 'dashboards/get_billings_by_status' => 'dashboards#get_billings_by_status', via: :get
    match 'dashboards/get_open_billings' => 'dashboards#get_open_billings', via: :get

    resources :installments, except: %i[new edit], controller: 'installments'

    resources :invoices, only: %i[index show], controller: 'invoices'

    resources :news, except: %i[new edit], controller: 'news'
    match 'news/:id/recover' => 'news#recover', via: %i[patch put]

    resources :orders, only: %i[index show], controller: 'orders' do
      resources :order_items, only: %i[index show], controller: 'orders/order_items'
      resources :order_ratings, except: %i[new edit], controller: 'orders/order_ratings'
    end

    resources :payment_conditions, only: %i[index show], controller: 'payment_conditions'

    resources :products, only: %i[index show update], controller: 'products'

    resources :product_derivations, only: %i[index show], controller: 'product_derivations'

    resources :representatives, only: %i[index show], controller: 'representatives'

    resources :services, except: %i[new edit], controller: 'services'
    match 'services/:id/recover' => 'services#recover', via: %i[put patch]
    match 'services/:id/attachments/:attachment_id/delete' => 'services#attachment_delete', via: %i[put patch]

    resources :transporters, only: %i[index show], controller: 'transporters'
  end
end
