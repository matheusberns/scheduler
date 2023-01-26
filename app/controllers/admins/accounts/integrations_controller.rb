# frozen_string_literal: true

module Admins::Accounts
  class IntegrationsController < BaseController
    def index
      @integrations = @account.integrations.list

      @integrations = apply_filters(@integrations, :active_boolean,
                                    :by_name,
                                    :by_email)

      render_index_json(@integrations, Integrations::IndexSerializer, 'integrations')
    end
  end
end
