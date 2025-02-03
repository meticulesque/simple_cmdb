module Api
  module V1
    class ConfigurationItemsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_configuration_item, only: [:show, :update, :destroy]

      # GET /api/v1/configuration_items
      def index
        configuration_items = ConfigurationItem.all
        render json: configuration_items
      end

      # GET /api/v1/configuration_items/:id
      def show
        render json: @configuration_item
      end
      # POST /api/v1/configuration_items
      def create
        authorize! :manage, ConfigurationItem
        configuration_item = ConfigurationItem.new(configuration_item_params)
        if configuration_item.save
          configuration_item.related_cis = ConfigurationItem.where(id: params[:configuration_item][:related_ci_ids])
          render json: configuration_item, status: :created
        else
          render json: { errors: configuration_item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize! :manage, ConfigurationItem
        if @configuration_item.update(configuration_item_params)
          @configuration_item.related_cis = ConfigurationItem.where(id: params[:configuration_item][:related_ci_ids])
          render json: @configuration_item
        else
          render json: { errors: @configuration_item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/configuration_items/:id
      def destroy
        authorize! :manage, ConfigurationItem
        @configuration_item.destroy
        head :no_content
      end

      private

      def set_configuration_item
        @configuration_item = ConfigurationItem.find(params[:id])
      end

      def configuration_item_params
        params.require(:configuration_item).permit(:name, :type, :status, :environment)
      end
    end
  end
end
