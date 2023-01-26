# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountAdmins::UsersController, type: :controller do
  ## INDEX ##
  describe 'INDEX users#index' do
    it 'should call users index' do
      get :index
      expect(response).to have_http_status 200
    end

    it 'should call users index with sortable' do
      get :index, params: { sort_property: 'id', sort_direction: 'desc' }
      expect(response).to have_http_status 200
    end

    it 'should call users index with scope by_name' do
      get :index, params: { name: Faker::Name.name }
      expect(response).to have_http_status 200
    end

    it 'should call users index with scope by_email' do
      get :index, params: { email: Faker::Internet.email }
      expect(response).to have_http_status 200
    end

    it 'should call users index with scope by_search' do
      get :index, params: { search: Faker::Name.name }
      expect(response).to have_http_status 200
    end
  end

  ## AUTOCOMPLETE ##
  describe 'AUTOCOMPLETE users#autocomplete' do
    it 'should call users autocomplete' do
      get :autocomplete
      expect(response).to have_http_status 200
    end

    it 'should call users autocomplete with scope by_search' do
      get :autocomplete, params: { search: Faker::Name.name }
      expect(response).to have_http_status 200
    end
  end

  ## SHOW ##
  describe 'SHOW users#show' do
    it 'should call users show' do
      get :show, params: { id: @current_user.id }
      expect(response).to have_http_status 200
    end

    it 'should call users show and raise RecordNotFound' do
      assert_raises ActiveRecord::RecordNotFound do
        get :show, params: { id: 0 }
      end
    end
  end

  ## CREATE ##
  describe 'CREATE users#create' do
    it 'should create user and return success status' do
      user_params = { user: FactoryBot.attributes_for(:user) }

      post :create, params: user_params
      expect(response).to have_http_status 201
    end

    it 'should create user and return unprocessable entity status' do
      user_params = { user: { email: nil } }

      post :create, params: user_params
      expect(response).to have_http_status 422
    end
  end

  ## UPDATE ##
  describe 'UPDATE users#update' do
    it 'should update user and return success status' do
      last_user_id = ::User.last.id
      user_params = FactoryBot.attributes_for(:user)

      put :update, params: { id: last_user_id, user: user_params }
      expect(response).to have_http_status 200

      patch :update, params: { id: last_user_id, user: user_params }
      expect(response).to have_http_status 200
    end

    it 'should update user and return unprocessable entity status' do
      last_user_id = ::User.last.id
      user_params = { email: nil, cpf: nil }

      put :update, params: { id: last_user_id, user: user_params }
      expect(response).to have_http_status 422

      patch :update, params: { id: last_user_id, user: user_params }
      expect(response).to have_http_status 422
    end
  end

  ## DESTROY ##
  describe 'DESTROY users#destroy' do
    it 'should destroy user and return success status' do
      user = FactoryBot.create(:user)

      delete :destroy, params: { id: user }
      expect(response).to have_http_status 200
    end

    # TODO: find a way to make a render_errors_json
    # it 'should destroy user and return unprocessable entity status' do
    #   last_user_id = ::User.last.id
    #
    #   delete :destroy, params: {id: last_user_id}
    #   expect(response).to have_http_status 422
    # end

    it 'should destroy user and raise RecordNotFound' do
      last_user_id = 0

      assert_raises ActiveRecord::RecordNotFound do
        delete :destroy, params: { id: last_user_id }
      end
    end
  end

  ## RECOVER ##
  describe 'RECOVER users#recover' do
    it 'should recover a deleted user and return success status' do
      deleted_user = FactoryBot.create(:user, :deleted)

      patch :recover, params: { id: deleted_user.id }
      expect(response).to have_http_status 200

      deleted_user = FactoryBot.create(:user, :deleted)

      put :recover, params: { id: deleted_user.id }
      expect(response).to have_http_status 200
    end

    # TODO: find a way to make a render_errors_json
    # it 'should recover a deleted user and return unprocessable entity status' do
    #   deleted_user = FactoryBot.create(:user, :deleted)
    #
    #   put :recover, params: {id: deleted_user.id}
    #   expect(response).to have_http_status 422
    # end
  end

  ## IMAGES ##
  describe 'IMAGES users#images' do
    it 'should upload a photo to user and return success status' do
      user = FactoryBot.create(:user)
      images_params = { photo: fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'ruby.png'),
                                                   'image/png'),
                        driver_license_photo: fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'ruby.png'),
                                                                  'image/png') }

      patch :images, params: { id: user.id, user: images_params }
      expect(response).to have_http_status 200

      put :images, params: { id: user.id, user: images_params }
      expect(response).to have_http_status 200
    end

    # TODO: find a way to make a render_errors_json
    # it 'should upload a photo to user and return unprocessable entity status' do
    #   user = FactoryBot.create(:user)
    #   photo_params = {photo: fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'ruby.png'), 'image/png')}
    #
    #   put :photo, params: { id: user.id, user: photo_params }
    #   expect(response).to have_http_status 200
    # end
  end
end
