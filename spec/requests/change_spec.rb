require 'rails_helper'

RSpec.describe Change, type: :request do
  include ActiveJob::TestHelper

  before(:each) do
    WebMock.allow_net_connect!

    # login
    @user = User.where(email: 'test@test.com').first_or_create
    get(token_session_path, params: { token: LoginToken.create(user: @user) })
  end

  it "can create multiple snapshots and send an email based on the last pair" do
    stub_request(:any, /faketimeserver.com/).to_rack(FakeTimeServer)

    page = Page.create!(url: "http://faketimeserver.com/now", user: @user, css_selector: 'body')
    @user.subscribe(page)

    4.times.each do
      PollPage.perform_all
      sleep 0.1
    end

    expect(page.page_snapshots.count).to eq 4 # verify we created the right number of snapshots

    Change.check

    expect(ActionMailer::Base.deliveries.length).to eq 1 # even though we had three snapshots, expect just one email
  end
end
