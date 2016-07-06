require 'rails_helper'

RSpec.describe Page, type: :feature do

  before :each do
    @user = create(:user)
    @login_path = token_session_path(token: LoginToken.create(user: @user)) # TODO: extract to helper
  end

  it "creates a new page from within the app" do
    page_name = "name #{SecureRandom.hex}"
    page_url = "http://#{SecureRandom.hex}.com"

    visit @login_path
    visit new_page_path
    fill_in "page[name]", with: page_name
    fill_in "page[url]", with: page_url
    fill_in "page[url]", with: page_url
    click_button "Create Page"

    visit pages_path
    expect(page.body).to include page_name
  end

end
