# frozen_string_literal: true

FactoryBot.define do
  password = '4dm1m$C0nn3ct'

  factory :user, class: User do
    account_id { ::Account.activated.first&.id || ::FactoryBot.create(:account)&.id }
    uuid { Faker::Internet.uuid }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    cpf { Faker::IDNumber.brazilian_cpf }
    password { password }
    password_confirmation { password }
    active { true }

    trait :common do
      is_admin { false }
      is_account_admin { false }
    end

    trait :admin do
      is_admin { true }
      account_id { nil }
    end

    trait :integrator do
      integration_id { ::Integration.activated.first&.id || ::FactoryBot.create(:integration)&.id }
      account_id { nil }
    end

    trait :account_admin do
      is_account_admin { true }
    end

    trait :deleted do
      active { false }
      deleted_at { Time.now }
    end

    trait :with_photo do
      photo { fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'ruby.png'), 'image/png') }
    end

    trait :with_driver_license_photo do
      driver_license_photo { fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'ruby.png'), 'image/png') }
    end
  end
end
