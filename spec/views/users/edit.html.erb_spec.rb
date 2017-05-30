require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  before(:each) do
    @user = create(:user)
    @current_user = @user
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input#user_first_name[name=?]", "user[first_name]"

      assert_select "input#user_last_name[name=?]", "user[last_name]"

      assert_select "input#user_email[name=?]", "user[email]"
    end
  end
end
