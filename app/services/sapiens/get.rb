module Sapiens
  class Get < ::Sapiens::Base
    def connection(base_url:, parameters:)
      options = {
        body: { sapiens_query: parameters }
      }

      response = Sapiens::Get.post("#{base_url}/consults", options)

      response['consults'].any? ? response['consults'] : 'Problemas ao consultar sapiens!'
    rescue StandardError => e
      { connection: { has_content: false, message: e.message } }
    end
  end
end
