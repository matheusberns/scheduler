# frozen_string_literal: true

module AccountAdmins
  class CustomersController < ::ApiController
    before_action :set_customer, only: :show

    def index
      @customers = @current_user.account.customers.list

      @customers = apply_filters(@customers, :by_cpf_cnpj,
                                 :by_name)

      render_index_json(@customers, ::Homepages::Customers::IndexSerializer, 'customers')
    end

    def autocomplete
      @customers = @current_user.account.customers.autocomplete

      @customers = @customers.by_id(@customer_ids) if @customer_ids.any?

      @customers = apply_filters(@customers, :active_boolean, :by_search)

      render_index_json(@customers, ::Homepages::Customers::AutocompleteSerializer, 'customers')
    end

    def show
      render_show_json(@customer, ::Homepages::Customers::ShowSerializer, 'customer', 200)
    end

    private

    def set_customer
      @customer = @current_user.account.customers.show.find(params[:id])
    end
  end
end
