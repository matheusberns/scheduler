# frozen_string_literal: true

Api::Application.routes.draw do
  scope module: :account_admins do
    match 'customers/autocomplete' => 'customers#autocomplete', via: :get
    resources :customers, only: %i[index show create update destroy]

    match 'current_account/show' => 'current_account/accounts#show', via: :get
    match 'current_account/update' => 'current_account/accounts#update', via: %i[put patch]
    match 'current_account/images' => 'current_account/accounts#images', via: %i[put patch]
    match 'current_account/tools' => 'current_account/tools#index', via: :get

    match 'tools/autocomplete' => 'tools#autocomplete', via: :get
    match 'tools' => 'tools#index', via: :get

    match 'user_admins/autocomplete' => 'users#autocomplete', via: :get
    resources :user_admins, only: %i[index show create update destroy]
    match 'user_admins/:id/recover' => 'users#recover', via: %i[put patch]
    match 'user_admins/:id/images' => 'users#images', via: %i[put patch]
  end
end
