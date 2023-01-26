# frozen_string_literal: true

module Enumerations
  class BudgetStatusController < ::ApiController
    before_action :set_object, only: :show

    def index
      render_enum_index_json(::BudgetStatusEnum.to_a, 'budget_status')
    end

    def show
      render_enum_show_json(@object, 'budget_status')
    end

    private

    def set_object
      @object = ::BudgetStatusEnum.to_a.find { |object| object[1].to_s == params[:id] }

      raise ::ActiveRecord::RecordNotFound if @object.nil?
    end
  end
end
