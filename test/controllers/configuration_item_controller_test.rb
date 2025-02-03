require "rails_helper"

RSpec.describe ConfigurationItemsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:configuration_item) { create(:configuration_item, name: "Test CI", ci_type: "Server", status: "Active", environment: "Production") }
  let!(:another_configuration_item) { create(:configuration_item, name: "Test CI 2", ci_type: "Application", status: "Retired", environment: "Staging") }

  before do
    sign_in user  # Assuming you have Devise authentication
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
      expect(response.status).to eq(200)
    end
  end

  describe "GET #show" do
    it "returns a success response for an existing CI" do
      get :show, params: { id: configuration_item.id }
      expect(response).to be_successful
      expect(response.status).to eq(200)
    end

    it "returns a not found response for a non-existent CI" do
      get :show, params: { id: 9999 }
      expect(response.status).to eq(404)
    end
  end

  describe "GET #filtered" do
    context "with filters" do
      it "returns filtered results based on environment" do
        get :filtered, params: { environment: "Production" }
        expect(assigns(:configuration_items).count).to eq(1)
        expect(assigns(:configuration_items).first.environment).to eq("Production")
      end

      it "returns filtered results based on type" do
        get :filtered, params: { ci_type: "Server" }
        expect(assigns(:configuration_items).count).to eq(1)
        expect(assigns(:configuration_items).first.ci_type).to eq("Server")
      end
    end

    context "without filters" do
      it "returns all configuration items" do
        get :filtered
        expect(assigns(:configuration_items).count).to eq(2)
      end
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
      expect(response.status).to eq(200)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new ConfigurationItem" do
        expect {
          post :create, params: { configuration_item: { name: "New CI", ci_type: "Server", status: "Active", environment: "Development" } }
        }.to change(ConfigurationItem, :count).by(1)
        expect(response.status).to eq(302)  # Should redirect after creation
      end
    end

    context "with invalid attributes" do
      it "does not create a new ConfigurationItem" do
        expect {
          post :create, params: { configuration_item: { name: "", ci_type: "Server", status: "Active", environment: "Development" } }
        }.to_not change(ConfigurationItem, :count)
        expect(response.status).to eq(200)  # Should re-render the form
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the configuration item" do
        patch :update, params: { id: configuration_item.id, configuration_item: { name: "Updated CI", ci_type: "Application" } }
        configuration_item.reload
        expect(configuration_item.name).to eq("Updated CI")
        expect(configuration_item.ci_type).to eq("Application")
        expect(response.status).to eq(302)  # Should redirect after update
      end
    end

    context "with invalid attributes" do
      it "does not update the configuration item" do
        patch :update, params: { id: configuration_item.id, configuration_item: { name: "", ci_type: "Server" } }
        expect(response.status).to eq(200)  # Should re-render the form
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the configuration item" do
      configuration_item_to_delete = create(:configuration_item)
      expect {
        delete :destroy, params: { id: configuration_item_to_delete.id }
      }.to change(ConfigurationItem, :count).by(-1)
      expect(response.status).to eq(302)  # Should redirect after deletion
    end
  end

  describe "GET #tree_data" do
    it "returns tree data for a configuration item" do
      get :tree_data, params: { id: configuration_item.id }
      expect(response.status).to eq(200)
      expect(response.body).to include("name")
    end

    it "returns error for a non-existent configuration item" do
      get :tree_data, params: { id: 9999 }
      expect(response.status).to eq(404)
    end
  end

  describe "GET #dashboard" do
    it "returns the dashboard data" do
      get :dashboard
      expect(assigns(:total_cis)).to eq(2)
      expect(assigns(:count_by_type)["Server"]).to eq(1)
      expect(assigns(:count_by_status)["Active"]).to eq(1)
      expect(response.status).to eq(200)
    end
  end
end
