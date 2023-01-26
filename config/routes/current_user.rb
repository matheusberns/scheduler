# frozen_string_literal: true

Api::Application.routes.draw do
  match 'current_user' => 'current_users#show', via: :get
  match 'current_user' => 'current_users#update', via: %i[put patch]
  match 'current_user/images' => 'current_users#images', via: %i[put patch]
  namespace :current_user, module: :current_users do
    resources :notification_tokens, controller: 'notification_tokens', only: %i[index create]
    match 'notification_tokens/destroy' => 'notification_tokens#destroy', via: %i[put patch]
  end
end
