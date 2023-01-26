# frozen_string_literal: true

module Accounts
  class AccountConsult < ::Accounts::Base
    def find
      request = self.class.get('/portal/account_by_uuid', @options)

      raise request.parsed_response unless request.ok?

      { success: true, account: request.parsed_response.deep_symbolize_keys[:account] }
    rescue StandardError => e
      { success: false, error: e }
    end

    private

    def initialize(uuid: nil)
      @options = {
        headers: {
          'Content-Type' => 'application/json'
        },
        query: { uuid: uuid }
      }
    end
  end
end
