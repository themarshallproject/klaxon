require 'rails_helper'

RSpec.describe "Integrations" do
  describe "GET /integrations" do
    before { login }

    it "returns http success" do
      get integrations_path
      expect(response).to have_http_status(:success)
    end
  end
end
