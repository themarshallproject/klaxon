require 'rails_helper'

RSpec.describe SafeString do
  before :all do
    @invalid_string = "one \255 two"
  end

  it "normally world error on string operations" do
    expect { @invalid_string.split(' ') }.to raise_error(ArgumentError)
  end

  it "safely coerces a non-utf8 string" do
    expect(described_class.coerce(@invalid_string).split(' ')).to eq [ "one", "two" ]
  end

  it "converts nil to an empty string" do
    expect(described_class.coerce(nil)).to eq ''
  end
end
