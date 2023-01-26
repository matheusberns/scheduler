# frozen_string_literal: true

module ImageDimensions
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  included do
    def photo_dimensions
      image_dimensions(photo)
    end

    def driver_license_dimensions
      image_dimensions(driver_license_photo)
    end
  end

  private

  def image_dimensions(image)
    return unless image&.attached?
    return unless ActiveStorage::Blob.service.exist?(image.blob.key)

    object = {
      id: image.id,
      url: active_storage_blob_path(image)
    }

    if image.variable?
      small = image.variant(resize: '275x275').processed
      medium = image.variant(resize: '550x550').processed
      larger = image.variant(resize: '1000x1000').processed

      object.merge!(
        {
          small: active_storage_representation(small),
          medium: active_storage_representation(medium),
          larger: active_storage_representation(larger)
        }
      )
    end

    object
  end

  def active_storage_blob_path(active_storage)
    return if active_storage.nil? || !active_storage.attached?

    rails_blob_path(active_storage, only_path: true)
  end

  def active_storage_representation(active_storage)
    return if active_storage.nil?

    rails_representation_url(active_storage, only_path: true)
  end
end
