# frozen_string_literal: true

# frozen_string_literal: true:hea

module Accounts
  class Base
    include ::HTTParty
    include ::ActiveModel::Model
    debug_output $stdout
    base_uri VELOW_ACCOUNTS_URL
  end
end
