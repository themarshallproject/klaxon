require 'rails_helper'

RSpec.describe TeamsIntegration, type: :model do
  it "generates the correct payload" do
    stub_request(:post, /test-webhook.com/)

    page = create(:page, :with_snapshots, snapshot_count: 2)
    teams = create(:teams_integration)

    teams.subscribe(page)

    change = page.latest_change
    expect(change.after.page).to eq page

    payload = teams.send_notification(change)
    expect(payload[:icon_url]).to start_with  'http'
    expect(payload[:icon_url]).to include '/images/klaxon-logo'
    expect(payload[:channel]).to eq teams.channel
    expect(payload[:username]).to include "Klaxon"
    expect(payload[:text]).to include page.name
    expect(payload[:text]).to include Rails.application.routes.url_helpers.page_change_url(change)
  end
end
