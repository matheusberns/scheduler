Rails.application.routes.draw do
  root to: 'rails/welcome#index'

  scope module: :homepages do

  end

  # Load others routes files
  draw(:account_admin)
  draw(:admin)
  draw(:current_user)
  draw(:enumeration)

  # Regions
  resources :via_ceps, controller: 'regions/via_ceps', only: %i[index]
  resources :states, controller: 'regions/states', only: :index
  resources :cities, controller: 'regions/cities', only: :index
  resources :districts, controller: 'regions/districts', only: :index

  # Cable
  mount ActionCable.server => '/cable'

  # Devise overrides
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    token_validations: 'overrides/token_validations',
    sessions: 'overrides/sessions',
    passwords: 'overrides/passwords'
  }
end