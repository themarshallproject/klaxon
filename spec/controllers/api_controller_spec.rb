require 'rails_helper'

RSpec.describe ApiController, type: :controller do

  before(:each) {
    WebMock.allow_net_connect!
    login
  }

  describe "/page-preview" do
    it "can query the tmp homepage" do

      url = 'https://www.themarshallproject.org'
      css_selector = 'header'

      get(:page_preview, params: { url: url, css_selector: css_selector })

      expect(response).to have_http_status(:success)

      data = JSON.parse(response.body)
      expect(data['css_selector']).to eq css_selector
      expect(data['url']).to eq url
      expect(data['match_text']).to include 'About'
    end
  end

  it "can get the users" do
    get(:users)
    expect(JSON.parse(response.body).count).to be > 0
  end

  it "creates a page by url and can update that page's selector" do
    url = "http://www.nytimes.com/"
    selector = ".first-column-region .story"

    @user = current_user

    # create the page
    post(:embed_find_page, params: { url: url })
    expect(response).to have_http_status(:success)
    data = JSON.parse(response.body)
    expect(data['url']).to eq url
    expect(data['css_selector']).to eq nil
    page = Page.find_by(url: url)
    expect(page.user).to eq @user

    # update the page
    post(:embed_update_page_selector, params: { id: page.id, css_selector: selector })
    data = JSON.parse(response.body)
    expect(data['css_selector']).to eq selector
    expect(data['user_id']).to eq @user.id
  end

  it "has stats"
  it "has subscriptions"
  it "has pages"

end
