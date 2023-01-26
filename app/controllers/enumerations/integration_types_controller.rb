# frozen_string_literal: true

module Enumerations
  class IntegrationTypesController < ::ApiController
    before_action :set_object, only: :show

    def index
      render_enum_index_json(::IntegrationTypeEnum.to_a, 'integration_types')
    end

    def show
      render_enum_show_json(@object, 'integration_type')
    end

    private

    def set_object
      @object = ::IntegrationTypeEnum.to_a.find { |object| object[1].to_s == params[:id] }

      raise ::ActiveRecord::RecordNotFound if @object.nil?
    end
  end
end
