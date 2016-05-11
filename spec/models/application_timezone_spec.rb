require 'rails_helper'

RSpec.describe "ApplicationTimezoneSetting", type: :model do

  it "has a default timezone" do
    ENV['TIME_ZONE'] = ''
    expect(Klaxon::Application.config.time_zone).to eq "Eastern Time (US & Canada)"
  end

end
