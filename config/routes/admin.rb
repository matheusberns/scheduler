# frozen_string_literal: true

Api::Application.routes.draw do
  scope module: :admins do
    match 'switch_to_user' => 'administrators#switch_to_user', via: :post

    match 'accounts/autocomplete' => 'accounts#autocomplete', via: :get
    resources :accounts, only: %i[index show create update destroy] do
      match 'tools/enable_all' => 'accounts/tools#enable_all', via: :post
      match 'tools/disable_all' => 'accounts/tools#disable_all', via: %i[put patch]
      resources :tools, controller: 'accounts/tools', only: %i[index show create update destroy]

      match 'web_services/autocomplete' => 'accounts/web_services#autocomplete', via: :get
      resources :web_services, controller: 'accounts/web_services', only: %i[index show update]

      match 'web_service_reports/autocomplete' => 'accounts/web_service_reports#autocomplete', via: :get
      resources :web_service_reports, controller: 'accounts/web_service_reports',
                                      only: %i[index show create update destroy]
      match 'web_service_reports/:id/recover' => 'accounts/web_service_reports#recover', via: %i[put patch]

      resources :web_service_report_exceptions, controller: 'accounts/web_service_report_exceptions', only: %i[index show create update destroy]
      match 'web_service_report_exceptions/:id/recover' => 'accounts/web_service_report_exceptions#recover', via: %i[put patch]

      match 'users/import' => 'accounts/users#import', via: :post
      resources :users, controller: 'accounts/users', only: :index

      resources :headquarters, controller: 'accounts/headquarters', only: %i[index show update]

      resources :integrations, controller: 'accounts/integrations', only: %i[index show create update destroy] do
        resources :users, controller: 'accounts/integrations/users'
        match 'users/:id/recover' => 'accounts/integrations/users#recover', via: %i[put patch]
      end
      match 'integrations/:id/recover' => 'accounts/integrations#recover', via: %i[put patch]
    end
    match 'accounts/:id/recover' => 'accounts#recover', via: %i[put patch]
    match 'accounts/:id/images' => 'accounts#images', via: %i[put patch]
    match 'accounts/:id/send_mail' => 'accounts#send_mail', via: :post
  end
end
