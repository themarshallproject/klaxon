require 'rails_helper'

RSpec.describe "Pages" do
  describe "GET /watching/pages/new" do
    before { login }

    it "pre-fills url and css_selector from query params" do
      get new_page_path, params: { url: "https://example.com", css_selector: "h1.title" }
      expect(response).to have_http_status(:success)
      expect(response.body).to include("https://example.com")
      expect(response.body).to include("h1.title")
    end

    it "returns a blank form when no params are given" do
      get new_page_path
      expect(response).to have_http_status(:success)
    end
  end
end
