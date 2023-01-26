# frozen_string_literal: true

module Homepages::Budgets
  class BudgetItemsController < BaseController
    before_action :set_budget_item, only: %i[show update destroy]

    def index
      @budget_items = @budget.budget_items.list

      @budget_items = apply_filters(@budget_items, :active_boolean,
                                    :by_product_id,
                                    :by_product_derivation_id)

      render_index_json(@budget_items, BudgetItems::IndexSerializer, 'budget_items')
    end

    def show
      render_show_json(@budget_item, BudgetItems::ShowSerializer, 'budget_item')
    end

    def create
      @budget_item = @budget.budget_items.new(budget_item_create_params)

      if @budget_item.save
        render_show_json(@budget_item, BudgetItems::ShowSerializer, 'budget_item', 201)
      else
        render_errors_json(@budget_item.errors.messages)
      end
    end

    def update
      if @budget_item.update(budget_item_update_params)
        render_show_json(@budget_item, BudgetItems::ShowSerializer, 'budget_item', 200)
      else
        render_errors_json(@budget_item.errors.messages)
      end
    end

    def destroy
      if @budget_item.destroy
        render_success_json
      else
        render_errors_json(@budget_item.errors.messages)
      end
    end

    def recover
      @budget_item = @budget.budget_items.list.active(false).find(params[:id])

      if @budget_item.recover
        render_show_json(@budget_item, BudgetItems::ShowSerializer, 'budget_item')
      else
        render_errors_json(@budget_item.errors.messages)
      end
    end

    private

    def set_budget_item
      @budget_item = @budget.budget_items.find(params[:id])
    end

    def budget_item_create_params
      budget_item_params.merge(created_by_id: @current_user.id, account_id: @current_user.account_id, customer_id: @current_user.customer_id)
    end

    def budget_item_update_params
      budget_item_params.merge(updated_by_id: @current_user.id)
    end

    def budget_item_params
      params
        .require(:budget_item)
        .permit(:quantity,
                :product_derivation_id,
                :product_id)
    end
  end
end
