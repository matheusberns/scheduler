# frozen_string_literal: true

require 'rubygems'
require 'net/ldap'

module ::ActiveDirectory::Ldap
  class Connection
    def resource
      return if @cpf.nil?

      @resource = find_user || create_user
    end

    def authenticated?
      @connection.bind
    end

    def persisted?
      @resource.present? && @resource.persisted?
    end

    private

    def initialize(username, password, account)
      @username = username.gsub('@', '')
      @password = password
      @account = account
      @host = @account.active_directory_host
      @base = @account.active_directory_base
      @username_with_domain = "#{@username}@#{@account.active_directory_domain}"

      make_connection
    end

    def make_connection
      @connection = Net::LDAP.new(
        host: @host,
        port: 389,
        base: @base,
        auth: {
          method: :simple,
          username: @username_with_domain,
          password: @password
        }
      )

      search_attributes if authenticated?
    end

    def search_attributes
      search_param = @username
      result_attrs = %w[mail employeeid name]

      # Build filter
      search_filter = Net::LDAP::Filter.eq('sAMAccountName', search_param)

      # Execute search
      @connection.search(filter: search_filter, attributes: result_attrs) do |item|
        @name = item.try(:name)&.first
        @cpf = item.try(:employeeid)&.first&.remove(/\W/)&.rjust(11, '0')
      end
    end

    def find_user
      user = ::User.by_account_id(@account.id).list.activated.find_by(cpf: @cpf)
      user.update_columns(username: @username) if user.present? && (user.username == @username)
      user
    end

    def create_user
      password = SecureRandom.base64

      user = ::User.new(
        name: @name,
        username: @username,
        cpf: @cpf,
        account_id: @account.id,
        password: password,
        password_confirmation: password
      )

      return unless user.save

      user
    end
  end
end
