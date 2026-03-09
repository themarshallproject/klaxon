require 'rails_helper'

RSpec.describe "API" do
  before {
    login
  }

  describe "/page-preview" do
    it "can query the tmp homepage" do
      url = 'https://www.themarshallproject.org'
      css_selector = 'header'

      stub_request(:get, "https://www.themarshallproject.org/").to_return(
        status: 200,
        body: '<html><body><header><a href="/about">About</a></header></body></html>',
        headers: { 'Content-Type' => 'text/html' }
      )

      get api_page_preview_path, params: { url: url, css_selector: css_selector }

      expect(response).to have_http_status(:success)

      data = JSON.parse(response.body)
      expect(data['css_selector']).to eq css_selector
      expect(data['url']).to eq url
      expect(data['match_text']).to include 'About'
    end
  end

  it "can get the users" do
    get api_users_path
    expect(JSON.parse(response.body).count).to be > 0
  end

  it "has stats"
  it "has subscriptions"
  it "has pages"
end
