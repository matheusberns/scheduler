# frozen_string_literal: true

module Enumerations
  class InvoiceTypesController < ::ApiController
    before_action :set_object, only: :show

    def index
      render_enum_index_json(::InvoiceTypeEnum.to_a, 'invoice_types')
    end

    def show
      render_enum_show_json(@object, 'invoice_type')
    end

    private

    def set_object
      @object = ::InvoiceTypeEnum.to_a.find { |object| object[1].to_s == params[:id] }

      raise ::ActiveRecord::RecordNotFound if @object.nil?
    end
  end
end
