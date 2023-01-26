# frozen_string_literal: true

class BaseSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::NumberHelper

  attributes :id,
             :uuid,
             :active,
             :created_at,
             :updated_at,
             :deleted_at

  def active_storage_blob_path(active_storage)
    return if active_storage.nil?

    rails_blob_path(active_storage, only_path: true)
  end

  def active_storage_representation(active_storage)
    return if active_storage.nil?

    rails_representation_url(active_storage, only_path: true)
  end

  def custom_params
    instance_options[:params]
  end

  def created_at
    object.created_at&.iso8601
  end

  def updated_at
    object.updated_at&.iso8601
  end

  def deleted_at
    object.deleted_at&.iso8601
  end
end
