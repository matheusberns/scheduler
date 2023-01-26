# frozen_string_literal: true

FactoryBot.define do
  factory :city, class: '::Region::City' do
    state_id { ::State.activated.last&.id || ::FactoryBot.create(:state) }
    name { Faker::Address.city }

    trait :deleted do
      active { false }
      deleted_at { Time.now }
    end
  end
end
