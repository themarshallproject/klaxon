require 'rails_helper'

RSpec.describe Page, type: :model do

  before :all do
    stub_request(:get, "https://www.themarshallproject.org/").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.themarshallproject.org', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => "<body>lorem ipsum lorem ipsum lorem ipsum</body>", :headers => {})

    @page = create(:page, url: "https://www.themarshallproject.org", css_selector: "body")
  end

  it "can download a webpage" do
    expect(@page.html.length).to be > 10
  end

  it "can extract a match text and match html" do
    expect(@page.match_text.length).to be > 10
    expect(@page.match_html.length).to be > 10
  end

  it "can calculate the hash of a page" do
    expect(@page.sha2_hash.length).to be == 64
  end

  it "has snapshots" do
    page = create(:page, :with_snapshots, snapshot_count: 1)
    expect(page.page_snapshots.length).to eq 1
  end

end
