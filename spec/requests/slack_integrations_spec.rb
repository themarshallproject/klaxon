require 'rails_helper'

RSpec.describe "SlackIntegrations", type: :request do
  describe "GET /slack_integrations" do
    it "works! (now write some real specs)" do
      get slack_integrations_path
      expect(response).to have_http_status(200)
    end
  end
end
