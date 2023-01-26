# frozen_string_literal: true

module Integrations
  class CustomersController < ::ApiController
    def create
      ::Representative.find_or_create_by({
                                           code: customer_create_params["representative"]["code"],
                                           name: customer_create_params["representative"]["name"],
                                           email: customer_create_params["representative"]["email"],
                                           account_id: @current_user.account_id
                                         }) if customer_create_params["representative"]

      @customer = @current_user.account.customers.find_or_initialize_by(
        cpf_cnpj: customer_create_params.try(:[], "cnpj"),
        code: customer_create_params.try(:[], "code")
      )

      @customer.name = customer_create_params.try(:[], "name")
      @customer.uuid = customer_create_params.try(:[], "uuid")
      @customer.nickname = customer_create_params.try(:[], "nickname")
      @customer.zipcode = customer_create_params.try(:[], "zipcode")
      @customer.address = customer_create_params.try(:[], "address")
      @customer.address_number = customer_create_params.try(:[], "address_number")
      @customer.email = customer_create_params.try(:[], "email")
      @customer.phone = customer_create_params.try(:[], "phone")
      @customer.secondary_phone = customer_create_params.try(:[], "secondary_phone")
      @customer.address_complement = customer_create_params.try(:[], "address_complement")
      @customer.social_reason = customer_create_params.try(:[], "social_reason")

      if @customer.valid?
        @customer.save!
        @customer.create_user(email: params["user"]["email"], password: params["user"]["password"])

        render_success_json
      else
        render_errors_json(@customer.errors.messages)
      end
    end

    private

    def customer_create_params
      customer_params.merge(created_by_id: @current_user.id)
    end

    def user_params
      params
        .require(:customer)
        .permit(:email,
                :password)
    end

    def customer_params
      params
        .require(:customer)
        .permit(:name,
                :code,
                :uuid,
                :cnpj,
                :nickname,
                :zipcode,
                :address,
                :address_number,
                :email,
                :phone,
                :secondary_phone,
                :address_complement,
                :social_reason)
    end
  end
end
