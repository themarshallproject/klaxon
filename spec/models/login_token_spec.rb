require 'rails_helper'

RSpec.describe LoginToken, type: :model do

  before :each do
    ENV['SECRET_KEY_BASE'] = SecureRandom.hex
    @user = create(:user)
  end

  it "can round-trip user->token->user" do
    token = LoginToken.create(user: @user)
    expect(LoginToken.decode(token: token)).to eq @user
  end

  it "fails if the SECRET_KEY_BASE changes" do
    token = LoginToken.create(user: @user)
    ENV['SECRET_KEY_BASE'] = SecureRandom.hex
    expect { LoginToken.decode(token: token) }.to raise_error
  end

  it "fails for a bad token" do
    expect { LoginToken.decode(token: "weird-token") }.to raise_error
  end

end
