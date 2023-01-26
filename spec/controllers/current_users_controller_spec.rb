# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CurrentUsersController, type: :controller do
  ## SHOW ##
  describe 'SHOW current_user#show' do
    it 'should call current_user show' do
      get :show, params: { id: @current_user.id }
      expect(response).to have_http_status 200
    end
  end

  ## UPDATE ##
  describe 'UPDATE current_user#update' do
    it 'should update current user and return success status' do
      user_params = FactoryBot.attributes_for(:user)

      put :update, params: { id: @current_user.id, user: user_params }
      expect(response).to have_http_status 200

      patch :update, params: { id: @current_user.id, user: user_params }
      expect(response).to have_http_status 200
    end

    it 'should update current user and return unprocessable entity status' do
      user_params = { email: nil, cpf: nil }

      put :update, params: { id: @current_user.id, user: user_params }
      expect(response).to have_http_status 422

      patch :update, params: { id: @current_user.id, user: user_params }
      expect(response).to have_http_status 422
    end
  end

  ## IMAGES ##
  describe 'IMAGES current_user#images' do
    it 'should upload a photo to current user and return success status' do
      images_params = { photo: fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'ruby.png'),
                                                   'image/png'),
                        driver_license_photo: fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'ruby.png'),
                                                                  'image/png') }

      patch :images, params: { id: @current_user.id, user: images_params }
      expect(response).to have_http_status 200

      put :images, params: { id: @current_user.id, user: images_params }
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
