class ConfigurationItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_configuration_item, only: [:show, :edit, :update, :destroy]

  def index
    @configuration_items = ConfigurationItem.all
  end

  def show
  end

  def new
    @configuration_item = ConfigurationItem.new
  end

  def create
    @configuration_item = ConfigurationItem.new(configuration_item_params_create)
    if @configuration_item.save
      update_relationships
      redirect_to @configuration_item, notice: "Configuration Item created successfully."
    else
      Rails.logger.debug { "ConfigurationItem save failed: #{@configuration_item.errors.full_messages.join(', ')}" }

      render :new
    end
  end

  def update
    if @configuration_item.update(configuration_item_params_update)
      p @configuration_item.ci_relationships
      update_relationships
      redirect_to @configuration_item, notice: "Configuration Item updated successfully."
    else
      render :edit
    end
  end

  def edit
  end

  def destroy
    @configuration_item.destroy
    redirect_to configuration_items_path, notice: "Configuration Item deleted successfully."
  end

  private

  def set_configuration_item
    @configuration_item = ConfigurationItem.find(params[:id])
  end

  def configuration_item_params_update
    params.require(:configuration_item).permit(:name, :ci_type, :status, :environment, related_ci_ids: [])
  end

  def configuration_item_params_create
    params.require(:configuration_item).permit(:name, :ci_type, :status, :environment)
  end

  def update_relationships
    @configuration_item.related_cis = ConfigurationItem.where(id: params[:configuration_item][:related_ci_ids].reject(&:blank?))
  end
end
