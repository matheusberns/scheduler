# frozen_string_literal: true

module Edited
  extend ActiveSupport::Concern

  included do
    def edited?
      object_was_edited?
    end
  end

  private

  def object_was_edited?
    mistake_margin = 5.seconds
    min_mistake_margin_created_at = created_at - mistake_margin
    max_mistake_margin_created_at = created_at + mistake_margin

    !updated_at.between?(min_mistake_margin_created_at, max_mistake_margin_created_at)
  end
end
