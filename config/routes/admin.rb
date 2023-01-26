# frozen_string_literal: true

Api::Application.routes.draw do
  scope module: :admins do
    match 'switch_to_user' => 'administrators#switch_to_user', via: :post

    match 'accounts/autocomplete' => 'accounts#autocomplete', via: :get
    resources :accounts, only: %i[index show create update destroy] do
      resources :customers, controller: 'accounts/customers', only: :index
      match 'tools/enable_all' => 'accounts/tools#enable_all', via: :post
      match 'tools/disable_all' => 'accounts/tools#disable_all', via: %i[put patch]
      resources :tools, controller: 'accounts/tools', only: %i[index show create update destroy]

      resources :users, controller: 'accounts/users', only: :index

      resources :integrations, controller: 'accounts/integrations', only: %i[index show create update destroy] do
        resources :users, controller: 'accounts/integrations/users'
        match 'users/:id/recover' => 'accounts/integrations/users#recover', via: %i[put patch]
      end
      match 'integrations/:id/recover' => 'accounts/integrations#recover', via: %i[put patch]
    end
    match 'accounts/:id/recover' => 'accounts#recover', via: %i[put patch]
    match 'accounts/:id/images' => 'accounts#images', via: %i[put patch]
  end
end
