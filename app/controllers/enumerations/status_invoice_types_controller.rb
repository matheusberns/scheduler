# frozen_string_literal: true

module Enumerations
  class StatusInvoiceTypesController < ::ApiController
    before_action :set_object, only: :show

    def index
      render_enum_index_json(::StatusInvoiceTypeEnum.to_a, 'status_invoice_types')
    end

    def show
      render_enum_show_json(@object, 'status_invoice_type')
    end

    private

    def set_object
      @object = ::StatusInvoiceTypeEnum.to_a.find { |object| object[1].to_s == params[:id] }

      raise ::ActiveRecord::RecordNotFound if @object.nil?
    end
  end
end
