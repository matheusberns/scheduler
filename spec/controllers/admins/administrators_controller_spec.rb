# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admins::AdministratorsController, type: :controller do
  describe 'SWITCH_TO_USER administrators#switch_to_user' do
    it 'should change the current user admin to normal user' do
      user = ::FactoryBot.create(:user)
      params = { user_id: user.id }

      post :switch_to_user, params: params

      expect(response.headers['uid']).to eq(user.email)
    end

    it 'should hit an error if user_id is admin' do
      user = ::FactoryBot.create(:user, :admin)
      params = { user_id: user.id }

      post :switch_to_user, params: params

      expect(response).to have_http_status 422
    end

    context do
      let(:current_user) { ::FactoryBot.create(:user) }
      before { request.headers.merge!(current_user.create_new_auth_token) }

      it 'should hit an error if current user is not admin' do
        user = ::FactoryBot.create(:user)
        params = { user_id: user.id }

        post :switch_to_user, params: params

        expect(response).to have_http_status 403
      end
    end
  end
end
