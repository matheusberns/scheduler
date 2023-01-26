# frozen_string_literal: true

Api::Application.routes.draw do
  namespace :enumerations do
    resources :integration_types, only: %i[index show]
  end
end
