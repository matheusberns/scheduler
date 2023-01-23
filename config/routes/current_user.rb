# frozen_string_literal: true

BarberApp::Application.routes.draw do
  match 'current_user' => 'current_users#show', via: :get
  match 'current_user' => 'current_users#update', via: %i[put patch]
  match 'current_user/change_password' => 'current_users#change_password', via: %i[put patch]
  match 'current_user/images' => 'current_users#images', via: %i[put patch]
  match 'current_user/accept_use_term' => 'current_users#accept_use_term', via: :patch

  namespace :current_user, module: :current_users do
    resources :emergency_contacts, controller: 'emergency_contacts', only: %i[index show create update destroy]
    match 'emergency_contacts/:id/recover' => 'emergency_contacts#recover', via: %i[put patch]

    resources :user_groups, controller: 'groups', only: :index

    resources :license_plates, controller: 'license_plates', except: %i[new edit]
    match 'license_plates/:id/recover' => 'license_plates#recover', via: %i[put patch]

    resources :notification_tokens, controller: 'notification_tokens', only: %i[index create]
    match 'notification_tokens/destroy' => 'notification_tokens#destroy', via: %i[put patch]
  end
end
