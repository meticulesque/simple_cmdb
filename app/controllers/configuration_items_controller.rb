class ConfigurationItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_configuration_item, only: [:show, :edit, :update, :destroy]

  def index
    @configuration_items = ConfigurationItem.all
  end

  def show
  end

  def filtered
    @configuration_items = ConfigurationItem.all

    # Apply filters if parameters are present
    @configuration_items = @configuration_items.where(environment: params[:environment]) if params[:environment].present?
    @configuration_items = @configuration_items.where(ci_type: params[:ci_type]) if params[:ci_type].present?

    render :index  # Reuse the index view to display filtered results
  end

  def new
    authorize! :manage, ConfigurationItem
    @configuration_item = ConfigurationItem.new
  end

  def create
    authorize! :manage, ConfigurationItem
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
    authorize! :manage, ConfigurationItem
    if @configuration_item.update(configuration_item_params_update)
      update_relationships
      redirect_to @configuration_item, notice: "Configuration Item updated successfully."
    else
      render :edit
    end
  end

  def edit
  end

  def destroy
    authorize! :manage, ConfigurationItem
    @configuration_item.destroy
    redirect_to configuration_items_path, notice: "Configuration Item deleted successfully."
  end

  def tree_data
    authorize! :read, ConfigurationItem
    root_ci = ConfigurationItem.find_by(id: params[:id]) || ConfigurationItem.first
    return render json: { error: "Configuration Item not found" }, status: :not_found unless root_ci

    visited = Set.new
    render json: format_tree(root_ci, visited)
  end

  def dashboard
    @total_cis = ConfigurationItem.count
    @count_by_type = ConfigurationItem.group(:ci_type).count
    @count_by_status = ConfigurationItem.group(:status).count
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
    @configuration_item.related_cis = ConfigurationItem.where(id: params[:configuration_item][:related_ci_ids])
  end

  def format_tree(ci, visited)
    return if visited.include?(ci.id)

    visited.add(ci.id)

    children = CiRelationship.where(parent_id: ci.id).map do |relationship|
      format_tree(ConfigurationItem.find_by(id: relationship.child_id), visited)
    end.compact

    { name: ci.name, children: children }
  end
end
