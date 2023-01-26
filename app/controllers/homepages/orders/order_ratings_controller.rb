# frozen_string_literal: true

module Homepages::Orders
  class OrderRatingsController < BaseController
    before_action :set_order_rating, only: %i[show update destroy]

    def index
      @order_ratings = @order.order_ratings.list

      @order_ratings = apply_filters(@order_ratings, :active_boolean)

      @ratings = []
      ::RatingTypeEnum.list.each do |rating_type|
        order_rating = @order_ratings.find { |rating| rating.rating_type == rating_type }

        @ratings << {
          id: order_rating.try(:id),
          ratingType: rating_type,
          rating: order_rating.try(:rating),
          description: order_rating.try(:description)
        }
      end

      @ratings << {
        rating: 5,
        average: true
      }

      render json: { orderRatings: @ratings }
    end

    def show
      render_show_json(@order_rating, Homepages::Orders::OrderRatings::ShowSerializer, 'order_rating')
    end

    def create
      @order_rating = @order.order_ratings.new(order_rating_create_params)

      if @order_rating.save
        render_show_json(@order_rating, Homepages::Orders::OrderRatings::ShowSerializer, 'order_rating', 201)
      else
        render_errors_json(@order_rating.errors.messages)
      end
    end

    def update
      if @order_rating.update(order_rating_update_params)
        render_show_json(@order_rating, Homepages::Orders::OrderRatings::ShowSerializer, 'order_rating', 200)
      else
        render_errors_json(@order_rating.errors.messages)
      end
    end

    def destroy
      if @order_rating.destroy
        render_success_json
      else
        render_errors_json(@order_rating.errors.messages)
      end
    end

    def recover
      @order_rating = @order.order_ratings.list.active(false).find(params[:id])

      if @order_rating.recover
        render_show_json(@order_rating, Homepages::Orders::OrderRatings::ShowSerializer, 'order_rating')
      else
        render_errors_json(@order_rating.errors.messages)
      end
    end

    private

    def set_order_rating
      @order_rating = @order.order_ratings.find(params[:id])
    end

    def order_rating_create_params
      order_rating_params.merge(created_by_id: @current_user.id, account_id: @current_user.account_id, customer_id: @current_user.customer_id)
    end

    def order_rating_update_params
      order_rating_params.merge(updated_by_id: @current_user.id)
    end

    def order_rating_params
      params
        .require(:rating)
        .permit(:rating_type,
                :rating,
                :description)
    end
  end
end
