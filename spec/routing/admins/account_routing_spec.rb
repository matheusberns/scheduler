# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes to the accounts controller', type: :routing do
  it 'need route to account index' do
    expect(get: '/accounts')
      .to route_to(controller: 'admins/accounts',
                   action: 'index')
  end

  it 'need route to account show' do
    expect(get: '/accounts/1')
      .to route_to(controller: 'admins/accounts',
                   action: 'show',
                   id: '1')
  end

  it 'need route to account create' do
    expect(post: '/accounts')
      .to route_to(controller: 'admins/accounts',
                   action: 'create')
  end

  it 'need route to account update' do
    expect(put: '/accounts/1')
      .to route_to(controller: 'admins/accounts',
                   action: 'update',
                   id: '1')
    expect(patch: '/accounts/1')
      .to route_to(controller: 'admins/accounts',
                   action: 'update',
                   id: '1')
  end

  it 'need route to account destroy' do
    expect(delete: '/accounts/1')
      .to route_to(controller: 'admins/accounts',
                   action: 'destroy',
                   id: '1')
  end

  it 'need route to account recover' do
    expect(put: '/accounts/1/recover')
      .to route_to(controller: 'admins/accounts',
                   action: 'recover',
                   id: '1')
    expect(patch: '/accounts/1/recover')
      .to route_to(controller: 'admins/accounts',
                   action: 'recover',
                   id: '1')
  end

  it 'need route to account images' do
    expect(put: '/accounts/1/images')
      .to route_to(controller: 'admins/accounts',
                   action: 'images',
                   id: '1')
    expect(patch: '/accounts/1/images')
      .to route_to(controller: 'admins/accounts',
                   action: 'images',
                   id: '1')
  end
end
