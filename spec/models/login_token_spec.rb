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
    expect { LoginToken.decode(token: token) }.to raise_error(JWT::VerificationError)
  end

  it "fails for a bad token" do
    expect { LoginToken.decode(token: "weird-token") }.to raise_error(JWT::DecodeError)
  end

  it "fails for a well-formed token but unsigned token" do
    fake_token = JWT.encode({ data: { user_id: 1 } }, 'some garbage key', 'none')
    expect { LoginToken.decode(token: fake_token) }.to raise_error(JWT::DecodeError)
  end

  it "fails for a well-formed token signed with the wrong key" do
    fake_token = JWT.encode({ data: { user_id: 1 } }, 'some garbage key', 'HS256')
    expect { LoginToken.decode(token: fake_token) }.to raise_error(JWT::VerificationError)
  end

  it "returns expired: true for an expired token" do
    real_token = JWT.encode({ data: { user_id: @user.id }, exp: 1.hour.ago.to_i }, LoginToken.secret_key, 'HS256')
    result = LoginToken.decode(token: real_token)
    expect(result[:user]).to eq @user
    expect(result[:expired]).to eq true
  end

end
