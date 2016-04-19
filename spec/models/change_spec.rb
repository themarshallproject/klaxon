require 'rails_helper'

RSpec.describe Change, type: :model do
  include ActiveJob::TestHelper

  it "is the edge between page_snapshots (happy path, already sorteda)" do
    page = create(:page, :with_snapshots, snapshot_count: 2)
    snapshots = page.page_snapshots
    expect(snapshots.count).to eq 2

    change = Change.create(before: snapshots.first, after: snapshots.last)
    expect(change.before).to eq(snapshots.first)
    expect(change.after).to eq(snapshots.last)
  end

  it "is not valid if the ordering is backward" do
    page = create(:page, :with_snapshots, snapshot_count: 2)
    snapshots = page.page_snapshots
    expect(snapshots.count).to eq 2

    change = Change.new(before: snapshots.first, after: snapshots.first)
    expect(change).to be_valid
  end

  it "sends email notifications for subscriptions on change creation" do
    page = create(:page, :with_snapshots, snapshot_count: 2)
    user = create(:user)

    user.subscribe(page)

    Change.check

    assert_enqueued_jobs 1
  end
end
