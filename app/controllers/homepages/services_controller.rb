# frozen_string_literal: true

module Homepages
  class ServicesController < ::ApiController
    before_action :set_service, only: %i[show update destroy attachment_delete]

    def index
      @services = @account.services.by_customer_id(@customer_ids).list

      @services = apply_filters(@services, :active_boolean,
                                :by_service_id,
                                :by_date_date_range)

      render_index_json(@services, Services::IndexSerializer, 'services')
    end

    def show
      render_show_json(@service, Services::ShowSerializer, 'service')
    end

    def create
      @service = @current_user.customer.services.new(service_create_params)

      if @service.save
        render_show_json(@service, Services::ShowSerializer, 'service', 201)
      else
        render_errors_json(@service.errors.messages)
      end
    end

    def update
      if @service.update(service_update_params)
        add_images if params[:service][:attachments]

        render_show_json(@service, Services::ShowSerializer, 'service', 200)
      else
        render_errors_json(@service.errors.messages)
      end
    end

    def destroy
      if @service.destroy
        render_success_json
      else
        render_errors_json(@service.errors.messages)
      end
    end

    def recover
      @service = @current_user.services.list.active(false).find(params[:id])

      if @service.recover
        render_show_json(@service, Services::ShowSerializer, 'service')
      else
        render_errors_json(@service.errors.messages)
      end
    end

    private

    def set_service
      @service = @current_user.services.find(params[:id])
    end

    def service_create_params
      service_params.merge(created_by_id: @current_user.id, account_id: @current_user.account_id, date: Time.now)
    end

    def service_update_params
      service_params.merge(updated_by_id: @current_user.id)
    end

    def service_params
      params
        .require(:service)
        .permit(:service_type,
                :status,
                :priority_type,
                :service_subtype,
                :description,
                :attachments)
    end
  end
end
