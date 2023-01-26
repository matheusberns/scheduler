# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes to the current_user controller', type: :routing do
  it 'route to current user show' do
    expect(get: '/current_user')
      .to route_to(controller: 'current_users', action: 'show')
  end

  it 'route to current user update' do
    expect(put: '/current_user')
      .to route_to(controller: 'current_users', action: 'update')
    expect(patch: '/current_user')
      .to route_to(controller: 'current_users', action: 'update')
  end

  it 'route to current user images' do
    expect(put: '/current_user/images')
      .to route_to(controller: 'current_users', action: 'images')
    expect(patch: '/current_user/images')
      .to route_to(controller: 'current_users', action: 'images')
  end
end
