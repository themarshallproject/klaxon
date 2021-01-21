require 'rails_helper'

RSpec.describe IntegrationsController, type: :controller do
  describe "GET #index" do
    before (:each) { login }

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
