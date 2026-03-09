require 'rails_helper'

RSpec.describe "SlackIntegrations" do
  let(:valid_attributes) {
    { channel: "#test-channel", webhook_url: "https://hooks.slack.com/services/test" }
  }

  let(:invalid_attributes) {
    { channel: "no-hash", webhook_url: "short" }
  }

  before { login }

  describe "GET /integrations/slack" do
    it "returns http success" do
      get slack_integrations_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /integrations/slack/:id" do
    it "returns http success" do
      slack_integration = SlackIntegration.create!(valid_attributes)
      get slack_integration_path(slack_integration)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /integrations/slack/new" do
    it "returns http success" do
      get new_slack_integration_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /integrations/slack/:id/edit" do
    it "returns http success" do
      slack_integration = SlackIntegration.create!(valid_attributes)
      get edit_slack_integration_path(slack_integration)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /integrations/slack" do
    context "with valid params" do
      it "creates a new SlackIntegration" do
        expect {
          post slack_integrations_path, params: { slack_integration: valid_attributes }
        }.to change(SlackIntegration, :count).by(1)
      end

      it "redirects to integrations path" do
        post slack_integrations_path, params: { slack_integration: valid_attributes }
        expect(response).to redirect_to(integrations_path)
      end
    end

    context "with invalid params" do
      it "does not create a new SlackIntegration" do
        expect {
          post slack_integrations_path, params: { slack_integration: invalid_attributes }
        }.not_to change(SlackIntegration, :count)
      end

      it "returns a successful response (renders new)" do
        post slack_integrations_path, params: { slack_integration: invalid_attributes }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PUT /integrations/slack/:id" do
    context "with valid params" do
      it "updates the requested slack_integration" do
        slack_integration = SlackIntegration.create!(valid_attributes)
        new_attributes = { channel: "#updated-channel", webhook_url: "https://hooks.slack.com/services/updated" }
        put slack_integration_path(slack_integration), params: { slack_integration: new_attributes }
        slack_integration.reload
        expect(slack_integration.channel).to eq("#updated-channel")
        expect(slack_integration.webhook_url).to eq("https://hooks.slack.com/services/updated")
      end

      it "redirects to integrations path" do
        slack_integration = SlackIntegration.create!(valid_attributes)
        put slack_integration_path(slack_integration), params: { slack_integration: valid_attributes }
        expect(response).to redirect_to(integrations_path)
      end
    end

    context "with invalid params" do
      it "does not update the slack_integration" do
        slack_integration = SlackIntegration.create!(valid_attributes)
        put slack_integration_path(slack_integration), params: { slack_integration: invalid_attributes }
        slack_integration.reload
        expect(slack_integration.channel).to eq("#test-channel")
      end

      it "returns a successful response (renders edit)" do
        slack_integration = SlackIntegration.create!(valid_attributes)
        put slack_integration_path(slack_integration), params: { slack_integration: invalid_attributes }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE /integrations/slack/:id" do
    it "destroys the requested slack_integration" do
      slack_integration = SlackIntegration.create!(valid_attributes)
      expect {
        delete slack_integration_path(slack_integration)
      }.to change(SlackIntegration, :count).by(-1)
    end

    it "redirects to the integrations list" do
      slack_integration = SlackIntegration.create!(valid_attributes)
      delete slack_integration_path(slack_integration)
      expect(response).to redirect_to(integrations_path)
    end
  end
end
