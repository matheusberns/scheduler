# frozen_string_literal: true

module AccountAdmins::Accounts
  class ShowSerializer < BaseSerializer
    attributes :users_timeout,
               :mandatory_comment,
               :timeout_in,
               :logo,
               :menu_background,
               :toolbar_background,
               :layout_space_bar

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
  end
end
