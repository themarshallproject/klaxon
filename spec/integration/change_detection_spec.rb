require 'rails_helper'

RSpec.describe "Change detection pipeline" do
  include ActiveSupport::Testing::TimeHelpers

  it "creates multiple snapshots and sends one email based on the last pair" do
    responses = 4.times.map do |i|
      { status: 200, body: "<html><body>snapshot-#{i}</body></html>" }
    end
    stub_request(:get, "http://example.com/page").to_return(responses)

    page = create(:page, url: "http://example.com/page", css_selector: 'body')
    page.user.subscribe(page)

    4.times do
      travel 1.hour
      PollPage.perform_all
    end

    expect(page.page_snapshots.count).to eq 4

    expect { Change.check }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
