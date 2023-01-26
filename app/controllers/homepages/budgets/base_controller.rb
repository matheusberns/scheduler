# frozen_string_literal: true

module Homepages::Budgets
  class BaseController < ::ApiController
    before_action :set_budget

    private

    def set_budget
      @budget = @current_user.budgets.activated.find(params[:budget_id]) if params[:budget_id]
    end
  end
end
