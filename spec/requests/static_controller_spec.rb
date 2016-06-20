require 'rails_helper'

RSpec.describe StaticController, type: :request do

  before(:each) do
    WebMock.allow_net_connect!

    # login
    @user = User.where(email: 'test@test.com').first_or_create
    get(token_session_path, token: LoginToken.create(user: @user))
  end

end
