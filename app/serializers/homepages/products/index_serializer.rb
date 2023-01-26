# frozen_string_literal: true

module Homepages::Products
  class IndexSerializer < BaseSerializer
    attributes :name,
               :code,
               :code_name,
               :uuid,
               :file

    def code_name
      "#{object.code} - #{object.name}"
    end

    def file
      return unless object.file.attached?

      Rails.application.routes.url_helpers.rails_blob_path(object.file, only_path: true)
    end
  end
end
