require 'rails_helper'

RSpec.describe PageSnapshot, type: :model do

  it "must have a page" do
    snapshot = PageSnapshot.new
    expect(snapshot.valid?).to be false
  end

  it "is valid with a page" do
    snapshot = create(:page_snapshot) # the factory creates a page
    expect(snapshot.valid?).to be true
  end

  it "is is invalid without a page" do
    snapshot = PageSnapshot.create
    expect(snapshot.valid?).to be false
  end

  it "can query the (directly) previous snapshot" do
    page1 = create(:page)
    page2 = create(:page)

    snapshot1 = create(:page_snapshot, page: page1, created_at: 5.minutes.ago)
    snapshot2 = create(:page_snapshot, page: page2, created_at: 4.minutes.ago)
    snapshot3 = create(:page_snapshot, page: page1, created_at: 3.minutes.ago)
    snapshot4 = create(:page_snapshot, page: page2, created_at: 2.minutes.ago)
    snapshot5 = create(:page_snapshot, page: page2, created_at: 1.minutes.ago)
    snapshot6 = create(:page_snapshot, page: page1, created_at: 0.minutes.ago)

    expect(snapshot3.previous).to eq snapshot1

    expect(snapshot5.previous).to eq snapshot4
    expect(snapshot6.previous).to eq snapshot3

    expect(snapshot1.siblings).to eq [snapshot3, snapshot6]
    expect(snapshot2.siblings).to eq [snapshot4, snapshot5]
  end

end
