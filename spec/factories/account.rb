# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    name { Faker::Name.name }
    base_url { Faker::Internet.url }
    uuid { Faker::Internet.uuid }
    active { true }

    trait :deleted do
      active { false }
      deleted_at { Time.now }
    end

    trait :with_logo do
      logo { fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'ruby.png'), 'image/png') }
    end

    trait :with_menu_background do
      menu_background { fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'ruby.png'), 'image/png') }
    end

    trait :with_toolbar_background do
      toolbar_background { fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'ruby.png'), 'image/png') }
    end
  end
end
