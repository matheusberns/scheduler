# frozen_string_literal: true

module AccountAdmins::Accounts::Tools
  class IndexSerializer < BaseSerializer
    attributes :name,
               :slug,
               :icon,
               :tool_code,
               :enabled,
               :module_type

    def module_type
      {
        id: object.module_type,
        name: object.module_type_humanize
      }
    end

    def enabled
      object.tool_accounts.pluck(:account_id).uniq.include? custom_params[:current_account_id]
    end
  end
end
