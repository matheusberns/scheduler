# frozen_string_literal: true

module Homepages::Customers
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
               :state,
               :city,
               :uuid
  end
end
