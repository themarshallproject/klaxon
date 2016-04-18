require 'rails_helper'

RSpec.describe SafeString, type: :model do

  before :all do
    @invalid_string = "one \255 two"
  end

  it "normally world error on string operations" do
    expect { @invalid_string.split(' ') }.to raise_error
  end

  it "safely coerces a non-utf8 string" do
    expect(SafeString.coerce(@invalid_string).split(' ')).to eq ["one", "two"]
  end

  it "converts nil to an empty string" do
    expect(SafeString.coerce(nil)).to eq ''
  end

end
