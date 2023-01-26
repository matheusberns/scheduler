# frozen_string_literal: true

module Homepages::News
  class IndexSerializer < BaseSerializer
    attributes :title,
               :description,
               :url,
               :url_description,
               :file,
               :uuid

    def file
      return unless object.file.attached?

      {
        id: object.file.id,
        url: active_storage_blob_path(object.file)
      }
    end
  end
end
