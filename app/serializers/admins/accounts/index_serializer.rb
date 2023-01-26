# frozen_string_literal: true

module Admins
  module Accounts
    class IndexSerializer < BaseSerializer
      attributes :name, :uuid, :primary_color,
                 :primary_colors,
                 :secondary_color,
                 :secondary_colors
    end
  end
end
