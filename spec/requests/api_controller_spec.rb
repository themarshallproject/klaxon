require 'rails_helper'

RSpec.describe ApiController, type: :request do

  before(:each) do
    WebMock.allow_net_connect!

    # login
    @user = User.where(email: 'test@test.com').first_or_create
    get(token_session_path, params: { token: LoginToken.create(user: @user) })
  end

  describe "/page-preview" do
    it "can query the tmp homepage" do

      url = 'https://www.themarshallproject.org'
      css_selector = 'header'

      get(api_page_preview_path, params: { url: url, css_selector: css_selector })

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

  it "creates a page by url and can update that page's selector" do
    url = "http://www.nytimes.com/"
    selector = ".first-column-region .story"

    # create the page
    post(embed_find_page_path, params: { url: url })
    expect(response).to have_http_status(:success)
    data = JSON.parse(response.body)
    expect(data['url']).to eq url
    expect(data['css_selector']).to eq nil
    page = Page.find_by(url: url)
    expect(page.user).to eq @user

    # update the page
    post(embed_update_page_selector_path, params: { id: page.id, css_selector: selector })
    data = JSON.parse(response.body)
    expect(data['css_selector']).to eq selector
    expect(data['user_id']).to eq @user.id
  end

  it "has stats"
  it "has subscriptions"
  it "has pages"

end
