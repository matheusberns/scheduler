# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes to the administrators controller', type: :routing do
  it 'need route to switch_to_user' do
    expect(post: '/switch_to_user')
      .to route_to(controller: 'admins/administrators', action: 'switch_to_user')
  end
end
