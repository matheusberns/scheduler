# frozen_string_literal: true

module Admins
  module Accounts
    module Customers
      class IndexSerializer < BaseSerializer
        attributes :name,
                   :code,
                   :uuid,
                   :cpf_cnpj,
                   :nickname,
                   :zipcode,
                   :address,
                   :address_number,
                   :email,
                   :phone,
                   :secondary_phone,
                   :address_complement,
                   :social_reason,
                   :account_id,
                   :state_id_id,
                   :city_id_id
      end
    end
  end
end
