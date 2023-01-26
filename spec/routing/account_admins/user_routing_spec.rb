# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes to the users controller', type: :routing do
  it 'need route to user index' do
    expect(get: '/users')
      .to route_to(controller: 'account_admins/users', action: 'index')
  end

  it 'need route to user show' do
    expect(get: '/users/1')
      .to route_to(controller: 'account_admins/users', action: 'show', id: '1')
  end

  it 'need route to user create' do
    expect(post: '/users')
      .to route_to(controller: 'account_admins/users', action: 'create')
  end

  it 'need route to user update' do
    expect(put: '/users/1')
      .to route_to(controller: 'account_admins/users', action: 'update', id: '1')
    expect(patch: '/users/1')
      .to route_to(controller: 'account_admins/users', action: 'update', id: '1')
  end

  it 'need route to user destroy' do
    expect(delete: '/users/1')
      .to route_to(controller: 'account_admins/users', action: 'destroy', id: '1')
  end

  it 'need route to user recover' do
    expect(put: '/users/1/recover')
      .to route_to(controller: 'account_admins/users', action: 'recover', id: '1')
    expect(patch: '/users/1/recover')
      .to route_to(controller: 'account_admins/users', action: 'recover', id: '1')
  end

  it 'need route to user images' do
    expect(put: '/users/1/images')
      .to route_to(controller: 'account_admins/users', action: 'images', id: '1')
    expect(patch: '/users/1/images')
      .to route_to(controller: 'account_admins/users', action: 'images', id: '1')
  end
end
