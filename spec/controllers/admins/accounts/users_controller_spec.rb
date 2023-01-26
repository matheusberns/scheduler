# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admins::Accounts::UsersController, type: :controller do
  ## INDEX ##
  describe 'INDEX accounts/users#index' do
    it 'should call accounts/users index' do
      get :index, params: { account_id: ::Account.first&.id }
      expect(response).to have_http_status 200
    end

    it 'should call accounts/users index with sortable' do
      get :index, params: { account_id: ::Account.first&.id,
                            sort_property: 'id',
                            sort_direction: 'desc' }
      expect(response).to have_http_status 200
    end

    it 'should call accounts/users index with scope by_name' do
      get :index, params: { account_id: ::Account.first&.id,
                            name: Faker::Name.name }
      expect(response).to have_http_status 200
    end

    it 'should call accounts/users index with scope by_email' do
      get :index, params: { account_id: ::Account.first&.id,
                            email: Faker::Internet.email }
      expect(response).to have_http_status 200
    end
  end
end
