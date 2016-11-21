require 'rails_helper'

RSpec.describe SqsIntegration, type: :model do
  it "generates the correct payload" do
    Aws.config[:stub_responses] = true

    page = create(:page, :with_snapshots, snapshot_count: 2)
    sqs = create(:sqs_integration)

    change = page.latest_change
    expect(change.after.page).to eq page

    payload = sqs.send_notification(change)
    expect(payload[:page_name]).to eq page.name
    expect(payload[:text]).to include page.name
    expect(payload[:change_page_url]).to eq Rails.application.routes.url_helpers.page_change_url(change)
    expect(payload[:url]).to eq change&.after&.page&.url
    expect(payload[:event]).to eq "update"
    expect(payload[:source]).to eq "klaxon"
    expect(payload[:type]).to eq "external"
    expect(payload[:eventTS]).to be > 1479510040
  end
end
