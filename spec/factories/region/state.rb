# frozen_string_literal: true

FactoryBot.define do
  factory :state, class: '::Region::State' do
    uf { Faker::Address.state_abbr }

    trait :deleted do
      active { false }
      deleted_at { Time.now }
    end
  end
end
