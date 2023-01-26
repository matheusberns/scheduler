# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    account_id { ::Account.activated.first&.id || ::FactoryBot.create(:account)&.id }
    user_id { ::User.activated.first&.id || ::FactoryBot.create(:user)&.id }
    title { ::Faker::Name.name }
    message { ::Faker::Quote.famous_last_words }
    notification_type { ::NotificationTypeEnum.list.sample }
    notification_origin { ::NotificationOriginEnum.list.sample }
  end
end
