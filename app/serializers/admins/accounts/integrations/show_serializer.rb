# frozen_string_literal: true

module Admins::Accounts::Integrations
  class ShowSerializer < BaseSerializer
    attributes :token,
               :description,
               :integration_type,
               :remote_ip
  end
end
