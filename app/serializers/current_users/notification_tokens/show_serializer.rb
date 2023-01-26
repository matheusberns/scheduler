# frozen_string_literal: true

module CurrentUsers::NotificationTokens
  class ShowSerializer < BaseSerializer
    attributes :token,
               :token_type

    def token_type
      {
        id: object.token_type,
        name: object.token_type_humanize
      }
    end
  end
end
