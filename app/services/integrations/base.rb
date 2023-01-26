# frozen_string_literal: true

require 'httparty'
require 'json'

module Integrations
  class Base
    include ::HTTParty
    include ::ActiveModel::Model

    class << self
      def i18n_scope
        :activerecord
      end
    end

    private

    def base_url
      if Rails.env.production?
        'https://rapt.volkdobrasil.com.br'
      elsif Rails.env.sandbox? || Rails.env.test?
        'https://raptteste.volkdobrasil.com.br'
      else
        'http://127.0.0.1:3001'
      end
    end
  end
end
