# frozen_string_literal: true

Api::Application.routes.draw do
  scope module: :account_admins do
    match 'current_account/show' => 'current_account/accounts#show', via: :get
    match 'current_account/update' => 'current_account/accounts#update', via: %i[put patch]
    match 'current_account/images' => 'current_account/accounts#images', via: %i[put patch]
    match 'current_account/tools' => 'current_account/tools#index', via: :get

    match 'groups/autocomplete' => 'groups#autocomplete', via: :get
    resources :groups, only: %i[index show create update destroy] do
      resources :group_users, controller: 'groups/users', only: %i[index create destroy]
      match 'group_users/:id/recover' => 'groups/users#recover', via: %i[put patch]

      match 'permissions/enable_all' => 'groups/permissions#enable_all', via: :post
      match 'permissions/disable_all' => 'groups/permissions#disable_all', via: %i[put patch]
      resources :permissions, controller: 'groups/permissions', only: %i[index create destroy]
    end
    match 'groups/:id/recover' => 'groups#recover', via: %i[put patch]

    match 'users/:id/recover' => 'users#recover', via: %i[put patch]
    match 'users/:id/images' => 'users#images', via: %i[put patch]
    match 'users/update_company_time' => 'users#update_company_time', via: :post
  end
end
