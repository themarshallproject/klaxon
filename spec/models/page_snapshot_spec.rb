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
    snapshot1 = create(:page_snapshot, created_at: 3.minutes.ago)
    snapshot2 = create(:page_snapshot, created_at: 2.minutes.ago)
    snapshot3 = create(:page_snapshot, created_at: 1.minutes.ago)
    snapshot4 = create(:page_snapshot, created_at: 0.minutes.ago)

    expect(snapshot2.previous).to eq snapshot1
    expect(snapshot3.previous).to eq snapshot2
    expect(snapshot4.previous).to eq snapshot3
  end

end
