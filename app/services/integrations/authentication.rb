module Integrations
  class Authentication < ::Integrations::Base

    def auth(external_service: nil)
      return unless external_service

      response = self.class.post(
        "#{external_service.base_url}/api/auth/sign_in",
        headers: {
          authkey: external_service.auth_key
        },
        body: {
          email: external_service.uid_access,
          password: external_service.password
        },
        verify: false
      )

      if response.code == 201
        Rails.cache.write('auth-session', { 'Content-Type' => 'application/json', 'access-token' => response.headers['access-token'], 'client' => response.headers[:client], 'uid' => response.headers[:uid], 'authkey' => external_service.auth_key }, expires_in: 15.minutes)
      else
        'Problemas ao tentar autenticar'
      end
    rescue StandardError => e
      { auth: { message: e.message } }
    end
  end
end
