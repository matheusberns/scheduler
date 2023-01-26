# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes to the user groups controller', type: :routing do
  it 'need route to user index' do
    expect(get: '/users/1/user_groups')
      .to route_to(controller: 'account_admins/users/groups',
                   action: 'index',
                   user_id: '1')
  end

  it 'need route to user create' do
    expect(post: '/users/1/user_groups')
      .to route_to(controller: 'account_admins/users/groups',
                   action: 'create',
                   user_id: '1')
  end

  it 'need route to user destroy' do
    expect(delete: '/users/1/user_groups/1')
      .to route_to(controller: 'account_admins/users/groups',
                   action: 'destroy',
                   user_id: '1',
                   id: '1')
  end

  it 'need route to user recover' do
    expect(put: '/users/1/user_groups/1/recover')
      .to route_to(controller: 'account_admins/users/groups',
                   action: 'recover',
                   user_id: '1',
                   id: '1')
    expect(patch: '/users/1/user_groups/1/recover')
      .to route_to(controller: 'account_admins/users/groups',
                   action: 'recover',
                   user_id: '1',
                   id: '1')
  end
end
