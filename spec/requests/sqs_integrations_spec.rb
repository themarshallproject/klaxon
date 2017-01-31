require 'rails_helper'

RSpec.describe "SqsIntegrations", type: :request do
  describe "GET /sqs_integrations" do
    it "works!" do
      get sqs_integrations_path
      expect(response).to have_http_status(200)
    end
  end
end
