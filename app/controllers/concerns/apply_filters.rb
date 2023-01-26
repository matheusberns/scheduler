# frozen_string_literal: true

module ApplyFilters
  extend ActiveSupport::Concern

  included do
    def apply_filters(objects, *scopes)
      scopes.each do |scope|
        scope_string = scope.to_s
        param_name = scope_string.sub('by_', '')
        params_item = params[param_name]

        # Date range
        if scope_string.include?('_date_range')
          param_name = param_name.sub('_date_range', '')
          scope_name = scope_string.sub('_date_range', '')
          scope = scope_name.to_sym

          first_param = params["start_#{param_name}".to_sym]
          last_param = params["end_#{param_name}".to_sym]

          objects = objects.send(scope, first_param, last_param)
          # Booleans
        elsif scope_string.include?('_boolean')
          param_name = param_name.sub('_boolean', '')
          scope_name = scope_string.sub('_boolean', '')
          params_item = params[param_name]
          scope = scope_name.to_sym

          case params_item.to_s
          when 'true'
            objects = objects.send(scope, true)
          when 'false'
            objects = objects.send(scope, false)
          end
        elsif params_item && objects.respond_to?(scope)
          objects = (params_item.to_s != 'true') && (params_item.to_s != 'false') ? objects.send(scope, params_item) : objects.send(scope)
        end
      end

      objects
    end
  end
end
