# frozen_string_literal: true

module Renders
  extend ActiveSupport::Concern
  include Sortable

  included do
    def render_index_json(objects, serializer, return_name, custom_params = nil)
      objects = sortable(objects)

      paginated_objects = objects.paginate(page: params[:page] || 1, per_page: params[:per_page] || 30)

      fields = params[:attributes].split(',') if params[:attributes].present?

      return_name = return_name.camelize(:lower) if params[:key_transform_camel_lower]

      json = {
        return_name => ActiveModelSerializers::SerializableResource.new(paginated_objects, {
                                                                          each_serializer: serializer,
                                                                          params: custom_params,
                                                                          fields: fields,
                                                                          key_transform: (params[:key_transform_camel_lower] ? 'camel_lower' : nil)
                                                                        }).as_json,
        count: objects.size
      }

      if custom_params&.key?(:can_edit) || custom_params&.key?(:can_manage_users) || custom_params&.key?(:account_name)
        custom_params = custom_params&.filter { |key| (key.eql? :can_edit) || (key.eql? :can_manage_users) || (key.eql? :account_name) }
        custom_params.deep_transform_keys! { |key| key.to_s.camelize(:lower) } if params[:key_transform_camel_lower]
        json.merge!(custom_params)
      end

      render json: json, status: :ok
    end

    def render_show_json(object, serializer, return_name, status = nil, custom_params = nil)
      object_all_fields = object.class.show.find(object.id)

      render_show(object_all_fields, serializer, return_name, status, custom_params)
    end

    def render_show_current_user_json(object, serializer, return_name, status = nil, custom_params = nil)
      object_all_fields = object.class.show(@current_user.id).find(object.id)

      render_show(object_all_fields, serializer, return_name, status, custom_params)
    end

    def render_show(object_all_fields, serializer, return_name, status, custom_params)
      status ||= 200
      fields = params[:attributes].split(',') if params[:attributes].present?

      return_name = return_name.camelize(:lower) if params[:key_transform_camel_lower]

      render json: {
        return_name => ActiveModelSerializers::SerializableResource.new(object_all_fields, {
                                                                          serializer: serializer,
                                                                          params: custom_params,
                                                                          fields: fields,
                                                                          key_transform: (params[:key_transform_camel_lower] ? 'camel_lower' : nil)
                                                                        }).as_json
      }, status: status
    end

    def render_json(object, serializer, return_name, status = nil, custom_params = nil)
      status ||= 200
      fields = params[:attributes].split(',') if params[:attributes].present?

      return_name = return_name.camelize(:lower) if params[:key_transform_camel_lower]

      object_serialized = if object
                            ActiveModelSerializers::SerializableResource.new(object, {
                                                                               serializer: serializer,
                                                                               params: custom_params,
                                                                               fields: fields,
                                                                               key_transform: (params[:key_transform_camel_lower] ? 'camel_lower' : nil)
                                                                             }).as_json
                          else
                            {}
                          end
      render json: { return_name => object_serialized }, status: status
    end

    def render_success_json(status: nil, body: nil)
      status ||= 200

      json = {}

      if body
        body.deep_transform_keys! { |key| key.to_s.camelize(:lower) } if params[:key_transform_camel_lower]

        json.merge!(body)
      end

      render json: json, status: status
    end

    def render_index_success_json(status: nil, body: nil, return_name: nil)
      status ||= 200

      body.each { |b| b.deep_transform_keys! { |key| key.to_s.camelize(:lower) } if params[:key_transform_camel_lower] }

      return_name = return_name.camelize(:lower) if params[:key_transform_camel_lower]

      render json: { return_name => body }, status: status
    end

    def render_enum_index_json(enumerators, return_name)
      return_name = return_name.camelize(:lower) if params[:key_transform_camel_lower]

      render json: {
        return_name => enumerators
          .map { |name, id| { id: id, name: name } }
          .sort_by { |object| object[:name] }
      }, status: :ok
    end

    def render_enum_show_json(enumerator, return_name)
      return_name = return_name.camelize(:lower) if params[:key_transform_camel_lower]

      render json: {
        return_name => { id: enumerator[1], name: enumerator[0] }
      }, status: :ok
    end

    def format_errors(errors)
      errors = errors.dup.deep_transform_keys! { |key| key.to_s.camelize(:lower) } if params[:key_transform_camel_lower]
      object_errors = {}
      errors.each do |field, field_errors|
        object_errors[field] = field_errors.first
      end
      object_errors
    end

    def render_errors_json(errors)
      object_errors = format_errors(errors)

      render json: { errors: object_errors }, status: :unprocessable_entity
    end

    def render_errors_with_object(errors, object, serializer, return_name)
      object_errors = format_errors(errors)

      fields = params[:attributes].split(',') if params[:attributes].present?

      return_name = return_name.camelize(:lower) if params[:key_transform_camel_lower]

      render json: {
        errors: object_errors,
        return_name => ActiveModelSerializers::SerializableResource.new(object, {
                                                                          serializer: serializer,
                                                                          fields: fields,
                                                                          key_transform: (params[:key_transform_camel_lower] ? 'camel_lower' : nil)
                                                                        }).as_json
      }, status: :unprocessable_entity
    end

    def render_error_json(error: nil, status: nil)
      status ||= 422

      json = error ? { errors: { base: error } } : {}

      render json: json, status: status
    end
  end
end
