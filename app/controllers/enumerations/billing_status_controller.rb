# frozen_string_literal: true

module Enumerations
  class BillingStatusController < ::ApiController
    before_action :set_object, only: :show

    def index
      render_enum_index_json(::BillingStatusEnum.to_a, 'billing_status')
    end

    def show
      render_enum_show_json(@object, 'billing_status')
    end

    private

    def set_object
      @object = ::BillingStatusEnum.to_a.find { |object| object[1].to_s == params[:id] }

      raise ::ActiveRecord::RecordNotFound if @object.nil?
    end
  end
end
