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
  end
end
