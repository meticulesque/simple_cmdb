# spec/controllers/configuration_items_controller_spec.rb
require "rails_helper"

RSpec.describe Api::ConfigurationItemsController, type: :controller do
  let!(:configuration_item) { create(:configuration_item, name: "Test CI", status: "Active") }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
      expect(response.status).to eq(200)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: configuration_item.id }
      expect(response).to be_successful
      expect(response.status).to eq(200)
    end

    it "returns a not found response for a non-existent CI" do
      get :show, params: { id: 9999 }
      expect(response.status).to eq(404)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new ConfigurationItem" do
        expect {
          post :create, params: { configuration_item: { name: "New CI", status: "Active", environment: "Production" } }
        }.to change(ConfigurationItem, :count).by(1)

        expect(response.status).to eq(201)
      end
    end

    context "with invalid attributes" do
      it "does not create a new ConfigurationItem" do
        expect {
          post :create, params: { configuration_item: { name: "", status: "Active", environment: "Production" } }
        }.to_not change(ConfigurationItem, :count)

        expect(response.status).to eq(422)  # Unprocessable entity
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the configuration item" do
        patch :update, params: { id: configuration_item.id, configuration_item: { name: "Updated CI" } }
        configuration_item.reload
        expect(configuration_item.name).to eq("Updated CI")

        expect(response.status).to eq(200)
      end
    end

    context "with invalid attributes" do
      it "does not update the configuration item" do
        patch :update, params: { id: configuration_item.id, configuration_item: { name: "" } }
        expect(response.status).to eq(422)  # Unprocessable entity
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the configuration item" do
      configuration_item_to_delete = create(:configuration_item)

      expect {
        delete :destroy, params: { id: configuration_item_to_delete.id }
      }.to change(ConfigurationItem, :count).by(-1)

      expect(response.status).to eq(204)  # No content
    end
  end
end
