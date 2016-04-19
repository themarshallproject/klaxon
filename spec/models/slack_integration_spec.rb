require 'rails_helper'

RSpec.describe SlackIntegration, type: :model do
  it "generates the correct payload" do
    stub_request(:post, /test-webhook.com/)

    page = create(:page, :with_snapshots, snapshot_count: 2)
    slack = create(:slack_integration)

    slack.subscribe(page)

    change = page.latest_change
    expect(change.after.page).to eq page

    payload = slack.send_notification(change)
    # expect(payload[:icon_url]).to start_with 'http'
    expect(payload[:icon_url]).to include '/assets/klaxon-logo'
    expect(payload[:channel]).to eq slack.channel
    expect(payload[:name]).to include "Klaxon"
    expect(payload[:text]).to include page.name
    expect(payload[:text]).to include Rails.application.routes.url_helpers.page_change_url(change)
  end
end
