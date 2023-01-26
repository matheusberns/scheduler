# frozen_string_literal: true

module Enumerations
  class ToolCodesController < ::ApiController
    before_action :set_object, only: :show

    def index
      render_enum_index_json(::ToolCodeEnum
                               .to_a
                               .reject { |enum| enum[1] == 1 },
                             'tool_codes')
    end

    def show
      render_enum_show_json(@object, 'tool_code')
    end

    private

    def set_object
      @object = ::ToolCodeEnum.to_a.find { |object| object[1].to_s == params[:id] }

      raise ::ActiveRecord::RecordNotFound if @object.nil?
    end
  end
end
