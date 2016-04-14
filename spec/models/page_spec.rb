require 'rails_helper'

RSpec.describe Page, type: :model do

  before :all do
    # TODO: seal this HTTP request off with VCR, similar
    @page = create(:page, url: "https://www.themarshallproject.org", css_selector: "body")
  end

  it "can download a webpage" do
    expect(@page.current_html.length).to be > 1000
  end

  it "can extract a match text and match html" do
    expect(@page.match_text.length).to be > 10
    expect(@page.match_html.length).to be > 10
  end

  it "can calculate the hash of a page" do
    expect(@page.hash.length).to be == 64
  end

end
