# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Gem for enumerations
  extend EnumerateIt

  # Base concerns
  include Base
  include Age
  include Edited
  include CreatorOverview
  include ImageDimensions
end
