# frozen_string_literal: true

module NotifyPermissionHelper
  extend ActiveSupport::Concern

  def permissions_params
    notify_permission = find_permission(::PermissionCodeEnum::NOTIFY_POST)
    fixed_permission = find_permission(::PermissionCodeEnum::FIXED_POST)

    notify_groups_ids = notify_permission.permission_groups.pluck(:group_id)
    fixed_groups_ids = fixed_permission.permission_groups.pluck(:group_id)

    user_notify_groups_ids = @current_user.user_groups.where(group_id: notify_groups_ids).pluck(:group_id)
    user_fixed_groups_ids = @current_user.user_groups.where(group_id: fixed_groups_ids).pluck(:group_id)

    { user_notify_groups_ids: user_notify_groups_ids, user_fixed_groups_ids: user_fixed_groups_ids }
  end

  private

  def find_permission(permission_code)
    ::Permission.list.find_by(account_id: @current_user.account_id,
                              code: permission_code)
  end
end
