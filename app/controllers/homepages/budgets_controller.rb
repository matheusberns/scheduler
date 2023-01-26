# frozen_string_literal: true

module Homepages
  class BudgetsController < ::ApiController
    before_action :set_budget, only: %i[show update destroy integrate]

    def index
      @budgets = @current_user.budgets.list

      @budgets = apply_filters(@budgets, :active_boolean,
                               :by_purchase_order,
                               :by_budget_number,
                               :by_status,
                               :by_date_date_range)

      render_index_json(@budgets, Budgets::IndexSerializer, 'budgets')
    end

    def show
      render_show_json(@budget, Budgets::ShowSerializer, 'budget')
    end

    def create
      @budget = @current_user.customer.budgets.new(budget_create_params)

      if @budget.save
        render_show_json(@budget, Budgets::ShowSerializer, 'budget', 201)
      else
        render_errors_json(@budget.errors.messages)
      end
    end

    def update
      if @budget.update(budget_update_params)
        add_images if params[:budget][:attachments]

        render_show_json(@budget, Budgets::ShowSerializer, 'budget', 200)
      else
        render_errors_json(@budget.errors.messages)
      end
    end

    def destroy
      if @budget.destroy
        render_success_json
      else
        render_errors_json(@budget.errors.messages)
      end
    end

    def recover
      @budget = @current_user.budgets.list.active(false).find(params[:id])

      if @budget.recover
        render_show_json(@budget, Budgets::ShowSerializer, 'budget')
      else
        render_errors_json(@budget.errors.messages)
      end
    end

    def integrate
      if @budget.update_columns(status: BudgetStatusEnum::INTEGRATING)
        render_success_json
      else
        render_errors_json(@budget.errors.messages)
      end
    end

    private

    def set_budget
      @budget = @current_user.budgets.find(params[:id])
    end

    def budget_create_params
      budget_params.merge(created_by_id: @current_user.id, account_id: @current_user.account_id, status: 1)
    end

    def budget_update_params
      budget_params.merge(updated_by_id: @current_user.id)
    end

    def budget_params
      params
        .require(:budget)
        .permit(:purchase_order)
    end
  end
end
