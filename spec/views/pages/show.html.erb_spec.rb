require 'rails_helper'

RSpec.describe "pages/show", type: :view do
  before(:each) do
    @page = assign(:page, Page.create!(
      :name => "MyText",
      :url => "MyText",
      :css_selector => "MyText",
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
  end
end
