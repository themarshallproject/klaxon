require 'rails_helper'

RSpec.describe Change, type: :model do
  include ActiveJob::TestHelper

  it "is the edge between page_snapshots (happy path, already sorted)" do
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

    snapshot1 = snapshots.first
    snapshot2 = snapshots.last

    snapshot1.created_at = 2.minutes.ago
    snapshot1.save

    snapshot2.created_at = 1.minutes.ago
    snapshot2.save

    expect(snapshots.count).to eq 2

    expect {
        Change.create!(before: snapshots.last, after: snapshots.first)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "sends email notification for subscriptions on new snapshots" do
    user = create(:user)
    page = create(:page, :with_snapshots, snapshot_count: 5)
    expect(page.page_snapshots.count).to be > 2 # make sure we're testing for multiple-snapshots issues

    # set up the subscriptions. users get emails for new changes.
    user.subscribe(page)

    # perform
    Change.check

    expect_before, expect_after = page.page_snapshots.order('created_at ASC').last(2)
    last_change = Change.order('created_at DESC').first
    expect(last_change.before).to eq expect_before
    expect(last_change.after).to  eq expect_after
    expect(ActionMailer::Base.deliveries.length).to eq 1
  end

  it "doesnt send anything if there is only one snapshot for a page" do
    user = create(:user)
    page = create(:page, :with_snapshots, snapshot_count: 1)
    expect(page.page_snapshots.count).to be 1

    # set up the subscriptions. users get emails for new changes
    user.subscribe(page)

    # perform
    Change.check

    expect(ActionMailer::Base.deliveries.length).to eq 0
  end

end
