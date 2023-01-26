# frozen_string_literal: true

class Dashboard < ::ApplicationRecord
  def self.get_annual_orders(current_user: nil)
    initial_date = (::Date.today - 12.months).at_beginning_of_month
    dashboard_data = []

    while initial_date <= ::Date.today.at_beginning_of_month
      month = I18n.translate("month.#{initial_date.month}")
      dashboard_data << [
        "#{month}/#{initial_date.year}",
        { v: 0, f: 'R$ 0,00' }
      ]
      initial_date += 1.month
    end

    orders = ::Order
               .select(:order_date, :customer_id, :value)
               .where('customer_id IN(:customer_id) AND orders.order_date > :date',
                      date: (::Time.now.at_beginning_of_month - 12.months), customer_id: current_user.customer_ids)

    orders.group_by { |order| order[:order_date]&.month }.each do |orders_month, group_orders|
      total_formatted = ::ActiveSupport::NumberHelper.number_to_currency(group_orders.pluck(:value).compact.sum, separator: ',', unit: 'R$', delimiter: '.', precision: 2)
      orders_month = I18n.translate("month.#{orders_month}")
      data = dashboard_data.find { |a, _b, _c| a == "#{orders_month}/#{group_orders[0].order_date.year}" }
      data[1] = { v: group_orders.pluck(:value).compact.sum, f: "#{total_formatted} (#{group_orders.size})" }
    end

    dashboard_data
  end

  def self.get_billings_by_status(current_user: nil)
    total_status = { 'Em aberto' => 0, 'Vencido' => 0, 'Liquidado' => 0 }

    start_date = ::Time.now.at_beginning_of_month
    end_date = ::Time.now.at_end_of_month

    billings = ::Billing
                 .select(:status,
                         :original_due_date,
                         :original_amount,
                         :amount)
                 .where('customer_id IN(:customer_id) AND billings.original_due_date > :start_date AND billings.original_due_date < :end_date',
                        start_date: start_date,
                        end_date: end_date,
                        customer_id: current_user.customer_ids)

    billings.each do |billing|
      paid = billing.original_amount - billing.amount
      open = billing.amount if billing.original_due_date >= Date.today
      late = billing.amount if billing.original_due_date < Date.today

      total_status['Liquidado'] += paid.to_f
      total_status['Em aberto'] += open.to_f
      total_status['Vencido'] += late.to_f
    end

    dashboard_data = []
    total_status.each { |status, valor|
      dashboard_data << [
        status,
        { v: valor, f: ::ActiveSupport::NumberHelper.number_to_currency(valor, separator: ',', unit: 'R$', delimiter: '.', precision: 2) }
      ]
    }

    dashboard_data
  end

  def self.get_open_billings(current_user: nil)
    dashboard_data = []

    billings = ::Billing
                 .select(:id,
                         :status,
                         :due_date,
                         :original_due_date,
                         :amount)
                 .where('customer_id IN(:customer_id) AND billings.status IN(:status)',
                        customer_id: current_user.customer_ids,
                        status: [::BillingStatusEnum::OPEN, ::BillingStatusEnum::LATE, ::BillingStatusEnum::OPEN_LATE])
                 .order(original_due_date: :asc)

    billings.group_by { |billing| I18n.l((billing[:original_due_date] || billing[:due_date]), format: :month_year) }.each do |billing_month, group_billings|
      total = group_billings.pluck(:amount).compact.sum

      dashboard_data << [
        billing_month,
        {
          v: total,
          f: ::ActiveSupport::NumberHelper.number_to_currency(total, separator: ',', unit: 'R$', delimiter: '.', precision: 2)
        }
      ]
    end

    dashboard_data
  end
end
