# frozen_string_literal: true

module Admins
  module Accounts
    class AutocompleteSerializer < ActiveModel::Serializer
      attributes :id, :name
    end
  end
end
