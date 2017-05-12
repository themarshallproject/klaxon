require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = create(:user)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First/)
    expect(rendered).to match(/Last/)
    expect(rendered).to match(/Email/)
  end
end
