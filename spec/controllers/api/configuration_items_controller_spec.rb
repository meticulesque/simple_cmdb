require "rails_helper"

RSpec.describe Api::ConfigurationItemsController, type: :controller do
  let!(:configuration_item) do
    create(
      :configuration_item,
      name: "Test CI 1",
      ci_type: "Server",
      status: "Active",
      environment: "Production"
    )
  end

  let(:user) { create(:user) }
  before do
    sign_in user
  end

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
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new ConfigurationItem" do
        expect {
          post :create, params: { configuration_item: { name: "New CI", status: "Active", environment: "Production", type: "Server"} }
        }.to change(ConfigurationItem, :count).by(1)

        expect(response.status).to eq(201)
      end
    end

    context "with invalid attributes" do
      it "does not create a new ConfigurationItem" do
        expect {
          post :create, params: { configuration_item: { name: "", status: "Active", environment: "Production" } }
        }.to_not change(ConfigurationItem, :count)

        expect(response.status).to eq(422)
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
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the configuration item" do
      configuration_item_to_delete = create(
        :configuration_item,
        name: "Test CI 2",
        ci_type: "Server",
        status: "Active",
        environment: "Production"
      )

      expect {
        delete :destroy, params: { id: configuration_item_to_delete.id }
      }.to change(ConfigurationItem, :count).by(-1)

      expect(response.status).to eq(204)
    end
  end
end
