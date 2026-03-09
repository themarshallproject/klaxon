require 'rails_helper'

RSpec.describe "Sessions" do
  describe "GET /login" do
    it "returns http success" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /login" do
    it "accepts an email for login" do
      user = create(:user)
      post create_session_path, params: { session: { email: user.email } }
      expect(response).not_to redirect_to(unknown_user_path)
    end

    it "is case-insensitive when checking emails" do
      user = create(:user)
      post create_session_path, params: { session: { email: user.email.upcase } }
      expect(response).not_to redirect_to(unknown_user_path)
    end
  end
end
