require 'rails_helper'

RSpec.describe LoginToken do
  before do
    @user = create(:user)
  end

  it "can round-trip user->token->user" do
    token = described_class.create(user: @user)
    expect(described_class.decode(token: token)).to eq @user
  end

  it "fails if the SECRET_KEY_BASE changes" do
    token = described_class.create(user: @user)
    allow(Rails.application).to receive(:secret_key_base).and_return(SecureRandom.hex)
    expect { described_class.decode(token: token) }.to raise_error(JWT::VerificationError)
  end

  it "fails for a bad token" do
    expect { described_class.decode(token: "weird-token") }.to raise_error(JWT::DecodeError)
  end

  it "fails for a well-formed token but unsigned token" do
    fake_token = JWT.encode({ data: { user_id: 1 } }, 'some garbage key', 'none')
    expect { described_class.decode(token: fake_token) }.to raise_error(JWT::DecodeError)
  end

  it "fails for a well-formed token signed with the wrong key" do
    fake_token = JWT.encode({ data: { user_id: 1 } }, 'some garbage key', 'HS256')
    expect { described_class.decode(token: fake_token) }.to raise_error(JWT::VerificationError)
  end

  it "returns expired: true for an expired token" do
    real_token = JWT.encode({ data: { user_id: @user.id }, exp: 1.hour.ago.to_i }, described_class.secret_key, 'HS256')
    result = described_class.decode(token: real_token)
    expect(result[:user]).to eq @user
    expect(result[:expired]).to be true
  end
end
