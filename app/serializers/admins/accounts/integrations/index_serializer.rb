# frozen_string_literal: true

module Admins::Accounts::Integrations
  class IndexSerializer < BaseSerializer
    attributes :token,
               :description,
               :integration_type,
               :remote_ip

    def integration_type
      {
        id: object.integration_type,
        name: object.integration_type_humanize
      }
    end
  end
end
