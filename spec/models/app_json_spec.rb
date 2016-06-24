require 'rails_helper'

RSpec.describe "HerokuAppJSONTemplate", type: :model do

  before :all do
    @path = File.join(Rails.root, "app.json")
  end

  it "has a parseable app.json" do
    hash = JSON.parse File.read(@path)
    expect(hash["name"]).to eq "Klaxon"
  end

end

