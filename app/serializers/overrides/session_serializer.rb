# frozen_string_literal: true

module Overrides
  class SessionSerializer < BaseSerializer
    attributes :name,
               :email,
               :is_admin,
               :is_account_admin,
               :is_headquarter,
               :many_headquarter,
               :headquarter_id,
               :account,
               :photo,
               :tools,
               :photo

    def many_headquarter
      object.headquarter_ids.size > 1
    end

    def is_headquarter
      object.headquarter?
    end

    def account
      return if object.account_id.nil?

      {
        id: object.account_id,
        logo: active_storage_blob_path(object.account_logo),
        toolbar_background: active_storage_blob_path(object.account_toolbar_background),
        menu_background: active_storage_blob_path(object.account_menu_background),
        primary_color: object.account_primary_color,
        secondary_color: object.account_secondary_color,
        primary_colors: object.account_primary_colors,
        secondary_colors: object.account_secondary_colors
      }
    end

    def tools
      return if object.account_id.nil?

      object.account.tools.map do |tool|
        tool.tool_code
      end
    end

    def photo
      object.photo_dimensions
    end
  end
end
