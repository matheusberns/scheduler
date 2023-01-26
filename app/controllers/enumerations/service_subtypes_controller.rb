# frozen_string_literal: true

module Enumerations
  class ServiceSubtypesController < ::ApiController
    before_action :set_object, only: :show

    def index
      render_enum_index_json(::ServiceSubtypeEnum.to_a, 'service_subtypes')
    end

    def show
      render_enum_show_json(@object, 'service_subtype')
    end

    private

    def set_object
      @object = ::ServiceSubtypeEnum.to_a.find { |object| object[1].to_s == params[:id] }

      raise ::ActiveRecord::RecordNotFound if @object.nil?
    end
  end
end
