# frozen_string_literal: true

module Ibge
  class Base
    include ::HTTParty
    include ::ActiveModel::Model
    debug_output $stdout
    base_uri CONSULT_IBGE_URL
  end
end
