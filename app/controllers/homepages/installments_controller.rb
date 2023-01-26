# frozen_string_literal: true

module Homepages
  class InstallmentsController < ::ApiController
    before_action :set_installment, only: %i[show update destroy attachment_delete]

    def index
      @installments = @current_user.installments.list

      @installments = apply_filters(@installments, :active_boolean,
                                    :by_installment_id,
                                    :by_date_date_range)

      render_index_json(@installments, Installments::IndexSerializer, 'installments')
    end

    def show
      render_show_json(@installment, Installments::ShowSerializer, 'installment')
    end

    def create
      @installment = @current_user.customer.installments.new(installment_create_params)

      if @installment.save
        render_show_json(@installment, Installments::ShowSerializer, 'installment', 201)
      else
        render_errors_json(@installment.errors.messages)
      end
    end

    def update
      if @installment.update(installment_update_params)
        add_images if params[:installment][:attachments]

        render_show_json(@installment, Installments::ShowSerializer, 'installment', 200)
      else
        render_errors_json(@installment.errors.messages)
      end
    end

    def destroy
      if @installment.destroy
        render_success_json
      else
        render_errors_json(@installment.errors.messages)
      end
    end

    def recover
      @installment = @current_user.installments.list.active(false).find(params[:id])

      if @installment.recover
        render_show_json(@installment, Installments::ShowSerializer, 'installment')
      else
        render_errors_json(@installment.errors.messages)
      end
    end

    private

    def set_installment
      @installment = @current_user.installments.find(params[:id])
    end

    def installment_create_params
      installment_params.merge(created_by_id: @current_user.id, account_id: @current_user.account_id, date: Time.now)
    end

    def installment_update_params
      installment_params.merge(updated_by_id: @current_user.id)
    end

    def installment_params
      params
        .require(:installment)
        .permit(:installment_type,
                :status,
                :priority_type,
                :installment_subtype,
                :description,
                :attachments)
    end
  end
end
