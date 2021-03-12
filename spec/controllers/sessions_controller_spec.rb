require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "accepts an email for login" do
      user = create(:user)
      post :create, params: { email: user.email }
      expect(response).not_to redirect_to(unknown_user_path)
    end

    it "is case-insensitive when checking emails" do
      user = create(:user)
      post :create, params: { email: user.email.upcase }
      expect(response).not_to redirect_to(unknown_user_path)
    end
  end
end
