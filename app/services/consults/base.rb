# frozen_string_literal: true

module Consults
  class Base
    include ::HTTParty
    include ::ActiveModel::Model
    debug_output $stdout
    base_uri CONSULT_DOCUMENT_URL
  end
end
