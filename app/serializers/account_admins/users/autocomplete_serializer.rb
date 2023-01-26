# frozen_string_literal: true

module AccountAdmins
  module Users
    class AutocompleteSerializer < ActiveModel::Serializer
      attributes :id, :name
    end
  end
end
