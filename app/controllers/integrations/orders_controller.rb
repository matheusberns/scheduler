# frozen_string_literal: true

module Integrations
  class OrdersController < ::ApiController
    def create
      order_params.each do |order|
        customer = Customer.find_or_initialize_by({ code: order['customer']['code'] })

        return unless customer

        new_order = ::Order.find_or_initialize_by({ order_number: order['order_number'] })

        if order['payment_condition']
          payment_condition = PaymentCondition.find_or_initialize_by({ code: order['payment_condition']['code'] })
          payment_condition.name = order['payment_condition']['name']
          payment_condition.account_id = @current_user.account_id
          payment_condition.save!

          new_order.payment_condition_id = payment_condition.id
        end

        if order['transporter']
          transporter = Transporter.find_or_initialize_by({ code: order['transporter']['code'] })
          transporter.name = order['transporter']['name']
          transporter.cnpj = order['transporter']['cnpj']
          transporter.account_id = @current_user.account_id
          transporter.save!

          new_order.transporter_id = transporter.id
        end

        order['order_items']&.each do |order_item|
          product = Product.find_or_initialize_by({ code: order_item['code'] })
          product.name = order_item['product_description'] if product.name.nil?
          product.account_id = @current_user.account_id if product.account_id.nil?
          product.save!

          product_derivation = ::ProductDerivation.find_or_create_by({
                                                                       code: order_item['derivation'],
                                                                       account_id: @current_user.account_id,
                                                                       product_id: product.id
                                                                     })

          new_order_item = new_order.order_items.find_or_initialize_by(
            {
              account_id: @current_user.account_id,
              product_code: order_item['product_code'],
              product_derivation_id: product_derivation.id
            }
          )
          new_order_item.product_id = product.id
          new_order_item.quantity = order_item['quantity']
          new_order_item.purchase_order = order['purchase_order']
          new_order_item.unit_price = order_item['pre_uni']
          new_order_item.final_value = order_item['vlr_fin']
          new_order_item.fcp_value = order_item['vlr_fcp']
          new_order_item.ics_value = order_item['vlr_ics']
          new_order_item.ipi_percentage = order_item['per_ipi']
          new_order_item.situation_item = order_item['situation_item']
          new_order_item.price_table = order_item['price_table']

          new_order_item.save!
        end

        new_order.customer_id = customer.id
        new_order.budget_date = order['budget_date']
        new_order.order_date = order['order_date']
        new_order.value = order['value'] || 0.0
        new_order.situation = order['situation']
        new_order.purchase_order = order['purchase_order']
        new_order.freight_type = order['freight_type']
        new_order.freight_value = order['freight_value']
        new_order.delivery_forecast = order['delivery_forecast']
        new_order.xls_file_name = order['xls_file_name']
        new_order.pdf_file_name = order['pdf_file_name']
        new_order.created_by_id = @current_user.id
        new_order.account_id = @current_user.account_id

        new_order.save!
      end
      render json: order_params.pluck(:order_number).join(',')
    end

    private

    def order_params
      params.require(:orders)
    end
  end
end
