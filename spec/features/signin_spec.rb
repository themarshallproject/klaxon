require 'rails_helper'

describe "the signin process", type: :feature do

  before :each do
    @user = create(:user)
  end

  it "sends a login email" do
    visit '/login'
    fill_in 'email', with: @user.email
    click_button 'Login'

    expect(page).to have_content 'Email Sent'

    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.to).to eq [@user.email]

    email_html = last_email.html_part.body.decoded
    email_doc = Nokogiri::HTML(email_html)
    email_links = email_doc.css('a').map{ |link| link[:href] }
    login_url = email_links.select{ |href| href.include?('/login/token?token=') }.first
    login_uri = URI.parse(login_url)
    login_path = [login_uri.path, login_uri.query].join('?')

    visit login_path
    expect(current_path).to eq '/'
    expect(Capybara.current_session.driver.request.cookies['user_id'].length).to be > 10
  end

  # it "can login via a magic link" do
  #   token =
  # end

end
