require 'rails_helper'

RSpec.describe Change, type: :model do

  it "is the edge between page_snapshots (easy case -- things in order)" do
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

end
