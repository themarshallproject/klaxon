require 'rails_helper'

RSpec.describe "pages/show", type: :view do
  before(:each) do
    @user = create(:user)
    @page = assign(:page, Page.create!(
      :user => @user,
      :name => "MyText",
      :url => "MyText",
      :css_selector => "MyText",
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(Regexp.new(@user.id.to_s))
  end
end
