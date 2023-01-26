# frozen_string_literal: true

Api::Application.routes.draw do
  scope module: :integrations do
    match 'integration/customers' => 'customers#create', via: :post, controller: 'integrations/customers'
    match 'integration/orders' => 'orders#create', via: :post, controller: 'integrations/orders'
    match 'integration/billings' => 'billings#create', via: :post, controller: 'integrations/billings'
    match 'integration/invoices' => 'invoices#create', via: :post, controller: 'integrations/invoices'
    match 'integration/installments' => 'installments#create', via: :post, controller: 'integrations/installments'
    match 'integration/products' => 'products#create', via: :post, controller: 'integrations/products'
    match 'integration/users' => 'users#destroy', via: :delete, controller: 'integrations/users'
  end
end
