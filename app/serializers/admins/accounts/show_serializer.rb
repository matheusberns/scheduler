# frozen_string_literal: true

module Admins
  module Accounts
    class ShowSerializer < BaseSerializer
      attributes :name,
                 :uuid,
                 :smtp_user,
                 :smtp_password,
                 :smtp_host,
                 :smtp_email,
                 :timeout_in,
                 :logo,
                 :menu_background,
                 :toolbar_background,
                 :created_by,
                 :updated_by,
                 :is_active_directory,
                 :active_directory_host,
                 :active_directory_base,
                 :active_directory_domain,
                 :base_url,
                 :primary_color,
                 :secondary_color,
                 :primary_colors,
                 :secondary_colors

      def logo
        return unless object.logo.attached?

        Rails.application.routes.url_helpers.rails_blob_path(object.logo,
                                                             only_path: true)
      end

      def menu_background
        return unless object.menu_background.attached?

        Rails.application.routes.url_helpers.rails_blob_path(object.menu_background,
                                                             only_path: true)
      end

      def toolbar_background
        return unless object.toolbar_background.attached?

        Rails.application.routes.url_helpers.rails_blob_path(object.toolbar_background,
                                                             only_path: true)
      end

      def created_by
        return unless object.created_by_id

        {
          id: object.created_by_id,
          name: object.created_by_name
        }
      end

      def updated_by
        return unless object.updated_by_id

        {
          id: object.updated_by_id,
          name: object.updated_by_name
        }
      end
    end
  end
end
