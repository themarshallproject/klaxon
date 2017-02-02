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

  it "strips whitespace from urls" do
    url = "http://nytimes.com"
    page = create(:page, url:  " "+url+" ")
    expect(page.url).to eq url
  end

  it "gracefully handles parsing an invalid uri" do
    weird_url = " bad:///site.com"
    page = build(:page, url: weird_url) # our sanitizer is on before_save, which does not run here
    expect(page.domain).to eq weird_url
    page.save
    expect(page.domain).to eq ''
  end

  it "deletes associated snapshots and changes upon deletion" do
    page = create(:page, :with_snapshots, snapshot_count: 3)
    page_id = page.id

    expect(page.page_snapshots.count).to eq 3
    expect { Change.check }.to change { Change.count }.by(1)
    expect { page.destroy }.to change { Change.count }.by(-1)

    expect(PageSnapshot.where(page_id: page_id).count).to eq 0
  end

end
