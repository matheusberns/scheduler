# frozen_string_literal: true

module Sapiens
  module Insert
    class Customer < ::Sapiens::Base
      def connection(params, account)
        params.each do |param|
          customer = ::Customer.find_or_initialize_by(
            {
              code: param['code'],
              cpf_cnpj: param['cpf_cnpj'],
              account_id: account.id
            }
          )
          customer.name = param['name']
          customer.save

          if param['contact_cpf']
            contact = customer.contacts.find_or_initialize_by(
              {
                cpf: param['contact_cpf'].to_s.remove(/\W/)&.rjust(11, '0'),
                account_id: account.id
              }
            )

            contact.name = param['contact_name']
            contact.phone = param['contact_fone']
            contact.email = param['contact_email']
            contact.save
          end

        end
      rescue StandardError => e
        { service: { message: e.message } }
      end
    end
  end
end
