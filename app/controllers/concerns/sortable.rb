# frozen_string_literal: true

module Sortable
  extend ActiveSupport::Concern

  included do
    def sortable(array_of_objects)
      params_sort_property = params[:sort_property]
      params_sort_direction = params[:sort_direction]

      return array_of_objects unless params_sort_property

      return array_of_objects unless array_of_objects.respond_to?('klass')

      sort_properties = params_sort_property.gsub(' ', '').split(',')
      sort_directions = params_sort_direction.gsub(' ', '').split(',') if params_sort_direction

      sort_properties.each_with_index do |sort_property, index|
        if sort_directions
          sort_direction = sort_directions[index]
          sort_directions_first = sort_directions.first

          sort_direction = sort_directions_first if sort_directions.size == 1 && sort_directions_first == 'asc' || sort_directions_first == 'desc'
        end

        order_method = "order_by_#{sort_property.to_s.downcase}".to_sym

        array_of_objects.klass.column_names

        if array_of_objects.respond_to? order_method
          array_of_objects = array_of_objects.send(order_method, sort_direction)
        elsif array_of_objects.klass.column_names.include?(sort_property.to_s)
          array_of_objects = sort_direction ? array_of_objects.order(sort_property.to_sym => sort_direction) : array_of_objects.order(sort_property)
        end
      end

      array_of_objects
    end
  end
end
