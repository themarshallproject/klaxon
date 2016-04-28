require 'rails_helper'

RSpec.describe ApiController, type: :request do

  before(:each) do
    user = User.where(email: 'test@test.com').first_or_create
    get(token_session_path, token: LoginToken.create(user: user))
  end

  describe "/page-preview" do
    it "can query the tmp homepage" do
      WebMock.allow_net_connect!
      url = 'https://www.themarshallproject.org'
      css_selector = 'header'

      get(api_page_preview_path, url: url, css_selector: css_selector)

      expect(response).to have_http_status(:success)

      data = JSON.parse(response.body)
      expect(data['css_selector']).to eq css_selector
      expect(data['url']).to eq url
      expect(data['match_text']).to include 'About'
    end
  end

  it "can get the users" do
    get(api_users_path)
    expect(JSON.parse(response.body).count).to be > 0
  end

  it "has stats"
  it "has subscriptions"
  it "has pages"

end
