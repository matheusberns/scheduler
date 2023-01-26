# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admins::Accounts::Integrations::UsersController, type: :controller do
  let!(:integration_id) { ::Integration.activated.first&.id || ::FactoryBot.create(:integration)&.id }

  ## INDEX ##
  describe 'INDEX accounts/integrations/users#index' do
    it 'should call user index' do
      get :index, params: { integration_id: integration_id }
      expect(response).to have_http_status 200
    end

    it 'should call user index with sortable' do
      get :index, params: { integration_id: integration_id,
                            sort_property: 'id',
                            sort_direction: 'desc' }
      expect(response).to have_http_status 200
    end
  end

  ## SHOW ##
  describe 'SHOW accounts/integrations/users#show' do
    it 'should call user show' do
      last_id = FactoryBot.create(:user, :integrator).id
      get :show, params: { integration_id: integration_id, id: last_id }
      expect(response).to have_http_status 200
    end

    it 'should call user show and raise RecordNotFound' do
      assert_raises ActiveRecord::RecordNotFound do
        get :show, params: { integration_id: integration_id, id: 0 }
      end
    end
  end

  ## CREATE ##
  describe 'CREATE accounts/integrations/users#create' do
    it 'should create user and return success status' do
      params = { integration_id: integration_id,
                 user: ::FactoryBot.attributes_for(:user, :integrator) }

      post :create, params: params
      expect(response).to have_http_status 201
    end

    it 'should create user and return unprocessable entity status' do
      params = { integration_id: integration_id,
                 user: { email: nil } }

      post :create, params: params
      expect(response).to have_http_status 422
    end
  end

  ## UPDATE ##
  describe 'UPDATE accounts/integrations/users#update' do
    it 'should update user and return success status' do
      last_id = FactoryBot.create(:user, :integrator).id
      params = FactoryBot.attributes_for(:user, :integrator)

      put :update, params: { integration_id: integration_id,
                             id: last_id,
                             user: params }
      expect(response).to have_http_status 200

      patch :update, params: { integration_id: integration_id,
                               id: last_id,
                               user: params }
      expect(response).to have_http_status 200
    end

    it 'should update user and return unprocessable entity status' do
      last_id = FactoryBot.create(:user, :integrator).id
      params = { integration_id: nil }

      put :update, params: { integration_id: integration_id,
                             id: last_id,
                             user: params }
      expect(response).to have_http_status 422

      patch :update, params: { integration_id: integration_id,
                               id: last_id,
                               user: params }
      expect(response).to have_http_status 422
    end
  end

  ## DESTROY ##
  describe 'DESTROY accounts/integrations/users#destroy' do
    it 'should destroy user and return success status' do
      last_id = ::FactoryBot.create(:user, :integrator)&.id

      delete :destroy, params: { integration_id: integration_id,
                                 id: last_id }
      expect(response).to have_http_status 200
    end

    # TODO: find a way to make a render_errors_json
    # it 'should destroy department and return unprocessable entity status' do
    #   last_department_id = ::Department.last.id
    #
    #   delete :destroy, params: {id: last_department_id}
    #   expect(response).to have_http_status 422
    # end

    it 'should destroy integrations and raise RecordNotFound' do
      last_id = 0

      assert_raises ActiveRecord::RecordNotFound do
        delete :destroy, params: { integration_id: integration_id,
                                   id: last_id }
      end
    end
  end

  ## RECOVER ##
  describe 'RECOVER accounts/integrations/users #recover' do
    it 'should recover a deleted user and return success status' do
      deleted = FactoryBot.create(:user, :integrator, :deleted)
      put :recover, params: { integration_id: integration_id,
                              id: deleted.id }
      expect(response).to have_http_status 200

      deleted = FactoryBot.create(:user, :integrator, :deleted)
      patch :recover, params: { integration_id: integration_id,
                                id: deleted.id }
      expect(response).to have_http_status 200
    end

    # TODO: find a way to make a render_errors_json
    # it 'should recover a deleted contact and return unprocessable entity status' do
    #   deleted_department = FactoryBot.create(:contact, :deleted)
    #
    #   put :recover, params: {id: deleted_department.id}
    #   expect(response).to have_http_status 422
    # end
  end
end
