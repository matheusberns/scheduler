# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    def disconnect
      ActionCable.server.remote_connections.where(current_user: current_user).disconnect
    end

    private

    def find_verified_user
      user = find_resource
      client = request.params['client']
      access_token = request.params['access-token']

      if user&.valid_token?(access_token, client)
        user
      else
        reject_unauthorized_connection
      end
    end

    def find_resource
      uid = request.params['uid']
      login_with_email = ::Devise.email_regexp.match? uid
      user_table_with_cpf = ::User.column_names.include? 'cpf'

      if login_with_email
        ::User.active(true).find_by('email' => uid)
      elsif user_table_with_cpf
        only_cpf_numbers = uid&.gsub(/\D/, '')
        ::User.active(true).find_by('cpf' => only_cpf_numbers)
      end
    end
  end
end
