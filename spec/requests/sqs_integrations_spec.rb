require 'rails_helper'

RSpec.describe "SqsIntegrations" do
  let(:valid_attributes) {
    { queue_url: "https://sqs.us-east-1.amazonaws.com/1234567890/fake-klaxon-sqs" }
  }

  let(:invalid_attributes) {
    { queue_url: "http://sqs.us-east-1.amazonaws.com/1234567890/fake-klaxon-sqs" }
  }

  before { login }

  describe "GET /integrations/sqs" do
    it "returns http success" do
      get sqs_integrations_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /integrations/sqs/:id" do
    it "returns http success" do
      sqs_integration = SqsIntegration.create!(valid_attributes)
      get sqs_integration_path(sqs_integration)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /integrations/sqs/new" do
    it "returns http success" do
      get new_sqs_integration_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /integrations/sqs/:id/edit" do
    it "returns http success" do
      sqs_integration = SqsIntegration.create!(valid_attributes)
      get edit_sqs_integration_path(sqs_integration)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /integrations/sqs" do
    context "with valid params" do
      it "creates a new SqsIntegration" do
        expect {
          post sqs_integrations_path, params: { sqs_integration: valid_attributes }
        }.to change(SqsIntegration, :count).by(1)
      end

      it "redirects to integrations path" do
        post sqs_integrations_path, params: { sqs_integration: valid_attributes }
        expect(response).to redirect_to(integrations_path)
      end
    end

    context "with invalid params" do
      it "does not create a new SqsIntegration" do
        expect {
          post sqs_integrations_path, params: { sqs_integration: invalid_attributes }
        }.not_to change(SqsIntegration, :count)
      end

      it "returns a successful response (renders new)" do
        post sqs_integrations_path, params: { sqs_integration: invalid_attributes }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PUT /integrations/sqs/:id" do
    context "with valid params" do
      it "updates the requested sqs_integration" do
        sqs_integration = SqsIntegration.create!(valid_attributes)
        new_attributes = { queue_url: "https://sqs.us-east-1.amazonaws.com/1234567890/new-fake-klaxon-sqs" }
        put sqs_integration_path(sqs_integration), params: { sqs_integration: new_attributes }
        sqs_integration.reload
        expect(sqs_integration.queue_url).to eq(new_attributes[:queue_url])
      end

      it "redirects to integrations path" do
        sqs_integration = SqsIntegration.create!(valid_attributes)
        put sqs_integration_path(sqs_integration), params: { sqs_integration: valid_attributes }
        expect(response).to redirect_to(integrations_path)
      end
    end

    context "with invalid params" do
      it "does not update the sqs_integration" do
        sqs_integration = SqsIntegration.create!(valid_attributes)
        put sqs_integration_path(sqs_integration), params: { sqs_integration: invalid_attributes }
        sqs_integration.reload
        expect(sqs_integration.queue_url).to eq(valid_attributes[:queue_url])
      end

      it "returns a successful response (renders edit)" do
        sqs_integration = SqsIntegration.create!(valid_attributes)
        put sqs_integration_path(sqs_integration), params: { sqs_integration: invalid_attributes }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE /integrations/sqs/:id" do
    it "destroys the requested sqs_integration" do
      sqs_integration = SqsIntegration.create!(valid_attributes)
      expect {
        delete sqs_integration_path(sqs_integration)
      }.to change(SqsIntegration, :count).by(-1)
    end

    it "redirects to the integrations list" do
      sqs_integration = SqsIntegration.create!(valid_attributes)
      delete sqs_integration_path(sqs_integration)
      expect(response).to redirect_to(integrations_path)
    end
  end
end
