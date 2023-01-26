# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Regions::StatesController, type: :controller do
  ## INDEX ##
  describe 'INDEX regions/states#index' do
    it 'should call regions/states index' do
      get :index
      expect(response).to have_http_status 200
    end

    it 'should call regions/states index with sortable' do
      get :index, params: { sort_property: 'id',
                            sort_direction: 'desc' }
      expect(response).to have_http_status 200
    end

    it 'should call regions/states index with scope by_uf' do
      get :index, params: { uf: Faker::Name.name }
      expect(response).to have_http_status 200
    end

    it 'should call regions/states index with scope by_email' do
      get :index, params: { email: Faker::Internet.email }
      expect(response).to have_http_status 200
    end
  end
end
