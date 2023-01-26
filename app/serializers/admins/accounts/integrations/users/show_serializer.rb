# frozen_string_literal: true

module Admins::Accounts::Integrations::Users
  class ShowSerializer < BaseSerializer
    attributes :name,
               :email,
               :last_sign_in_at

    def last_sign_in_at
      object.last_sign_in_at&.iso8601
    end
  end
end
