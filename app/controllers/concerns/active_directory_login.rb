# frozen_string_literal: true

module ActiveDirectoryLogin
  extend ActiveSupport::Concern

  def find_active_directory_resource
    username = already_registered_username || @login_value
    password = resource_params[:password]

    @active_directory = ::ActiveDirectory::Ldap::Connection.new(username, password, @login_account)

    return if @active_directory.nil?

    @active_directory.resource
  end

  def already_registered_username
    resource = find_active_devise_resource
    resource_already_registered = resource.present?

    return unless resource_already_registered && resource.username.present?

    resource.username
  end

  def valid_active_directory_resource?
    return if @active_directory.nil?

    @exceeded_attempts = @active_directory.as_json['connection']['result']['ldap_result']['errorMessage'].include?('data 775') unless @active_directory.authenticated?

    @active_directory.authenticated? && @active_directory.persisted?
  end
end
