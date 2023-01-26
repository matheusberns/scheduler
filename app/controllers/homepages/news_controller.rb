# frozen_string_literal: true

module Homepages
  class NewsController < ::ApiController
    before_action :validate_permission, only: :create
    before_action :set_new, only: %i[show update destroy]

    def index
      @news = New.list

      @news = apply_filters(@news, :active_boolean,
                            :by_title)

      render_index_json(@news, News::IndexSerializer, 'news')
    end

    def show
      render_show_json(@new, News::ShowSerializer, 'new')
    end

    def create
      @new = New.new(new_create_params)

      if @new.save
        render_show_json(@new, News::ShowSerializer, 'new', 201)
      else
        render_errors_json(@new.errors.messages)
      end
    end

    def update
      if @new.update(new_update_params)
        render_show_json(@new, News::ShowSerializer, 'new', 200)
      else
        render_errors_json(@new.errors.messages)
      end
    end

    def destroy
      if @new.destroy
        render_success_json
      else
        render_errors_json(@new.errors.messages)
      end
    end

    def recover
      @new = New.list.active(false).find(params[:id])

      if @new.recover
        render_show_json(@new, News::ShowSerializer, 'new')
      else
        render_errors_json(@new.errors.messages)
      end
    end

    private

    def validate_permission
      render_error_json(status: 405) unless @current_user.is_account_admin
    end

    def set_new
      @new = New.find(params[:id])
    end

    def new_create_params
      new_params.merge(created_by_id: @current_user.id)
    end

    def new_update_params
      new_params.merge(updated_by_id: @current_user.id)
    end

    def new_params
      params
        .require(:new)
        .permit(:title,
                :description,
                :url_description,
                :url,
                :file)
    end
  end
end
