# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admins::AccountsController, type: :controller do
  ## INDEX ##
  describe 'INDEX accounts#index' do
    it 'should call accounts index' do
      get :index
      expect(response).to have_http_status 200
    end

    it 'should call accounts index with sortable' do
      get :index, params: { sort_property: 'id', sort_direction: 'desc' }
      expect(response).to have_http_status 200
    end

    it 'should call accounts index with scope by_name' do
      get :index, params: { name: Faker::Name.name }
      expect(response).to have_http_status 200
    end

    it 'should call accounts index with scope by_search' do
      get :index, params: { search: Faker::Name.name }
      expect(response).to have_http_status 200
    end
  end

  ## AUTOCOMPLETE ##
  describe 'AUTOCOMPLETE accounts#autocomplete' do
    it 'should call accounts autocomplete' do
      get :autocomplete
      expect(response).to have_http_status 200
    end

    it 'should call accounts autocomplete with scope by_search' do
      get :autocomplete, params: { search: Faker::Name.name }
      expect(response).to have_http_status 200
    end
  end

  ## SHOW ##
  describe 'SHOW accounts#show' do
    it 'should call accounts show' do
      last_account_id = FactoryBot.create(:account).id
      get :show, params: { id: last_account_id }
      expect(response).to have_http_status 200
    end

    it 'should call accounts show and raise RecordNotFound' do
      assert_raises ActiveRecord::RecordNotFound do
        get :show, params: { id: 0 }
      end
    end
  end

  ## CREATE ##
  describe 'CREATE accounts#create' do
    it 'should create account and return success status' do
      account_params = { account: FactoryBot.attributes_for(:account) }

      post :create, params: account_params
      expect(response).to have_http_status 201
    end

    it 'should create account and return unprocessable entity status' do
      account_params = { account: { name: nil } }

      post :create, params: account_params
      expect(response).to have_http_status 422
    end
  end

  ## UPDATE ##
  describe 'UPDATE accounts#update' do
    it 'should update account and return success status' do
      last_account_id = FactoryBot.create(:account).id
      account_params = FactoryBot.attributes_for(:account)

      put :update, params: { id: last_account_id, account: account_params }
      expect(response).to have_http_status 200

      patch :update, params: { id: last_account_id, account: account_params }
      expect(response).to have_http_status 200
    end

    it 'should update account and return unprocessable entity status' do
      last_account_id = FactoryBot.create(:account).id
      account_params = { name: nil }

      put :update, params: { id: last_account_id, account: account_params }
      expect(response).to have_http_status 422

      patch :update, params: { id: last_account_id, account: account_params }
      expect(response).to have_http_status 422
    end
  end

  ## DESTROY ##
  describe 'DESTROY accounts#destroy' do
    it 'should destroy account and return success status' do
      last_account_id = FactoryBot.create(:account).id

      delete :destroy, params: { id: last_account_id }
      expect(response).to have_http_status 200
    end

    # TODO: find a way to make a render_errors_json
    # it 'should destroy account and return unprocessable entity status' do
    #   last_account_id = ::Account.last.id
    #
    #   delete :destroy, params: {id: last_account_id}
    #   expect(response).to have_http_status 422
    # end

    it 'should destroy account and raise RecordNotFound' do
      last_account_id = 0

      assert_raises ActiveRecord::RecordNotFound do
        delete :destroy, params: { id: last_account_id }
      end
    end
  end

  ## RECOVER ##
  describe 'RECOVER accounts#recover' do
    it 'should recover a deleted account and return success status' do
      deleted_account = FactoryBot.create(:account, :deleted)

      patch :recover, params: { id: deleted_account.id }
      expect(response).to have_http_status 200

      deleted_account = FactoryBot.create(:account, :deleted)

      put :recover, params: { id: deleted_account.id }
      expect(response).to have_http_status 200
    end

    # TODO: find a way to make a render_errors_json
    # it 'should recover a deleted account and return unprocessable entity status' do
    #   deleted_account = FactoryBot.create(:account, :deleted)
    #
    #   put :recover, params: {id: deleted_account.id}
    #   expect(response).to have_http_status 422
    # end
  end

  ## IMAGES ##
  describe 'IMAGES accounts#images' do
    it 'should upload a logo to account and return success status' do
      account = FactoryBot.create(:account)
      images_params = { logo: fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'ruby.png'),
                                                  'image/png'),
                        toolbar_background: fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'ruby.png'),
                                                                'image/png'),
                        menu_background: fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'ruby.png'),
                                                             'image/png') }

      patch :images, params: { id: account.id, account: images_params }
      expect(response).to have_http_status 200

      put :images, params: { id: account.id, account: images_params }
      expect(response).to have_http_status 200
    end

    # TODO: find a way to make a render_errors_json
    # it 'should upload a logo to account and return unprocessable entity status' do
    #   account = FactoryBot.create(:account)
    #   photo_params = {logo: fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'ruby.png'), 'image/png')}
    #
    #   put :logo, params: { id: account.id, account: photo_params }
    #   expect(response).to have_http_status 200
    # end
  end
end
