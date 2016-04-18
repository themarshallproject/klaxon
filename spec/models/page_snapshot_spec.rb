require 'rails_helper'

RSpec.describe PageSnapshot, type: :model do

  it "must have a page" do
    snapshot = PageSnapshot.new
    expect(snapshot.valid?).to be false
  end

  it "is valid with a page" do
    snapshot = create(:page_snapshot)
    expect(snapshot.valid?).to be true
  end

end
