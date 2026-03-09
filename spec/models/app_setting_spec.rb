require 'rails_helper'

RSpec.describe AppSetting do
  it "returns false/empty if no app_setting" do
    described_class.where(key: 'default_host').delete_all
    expect(described_class.default_host_exists?).to be false
    expect(described_class.default_host).to eq ''
  end

  it "gets the default host if it's set" do
    test_host = SecureRandom.hex
    setting = described_class.set_default_host(test_host)

    expect(described_class.default_host_exists?).to be true
    expect(described_class.default_host).to eq test_host

    rails_host = Rails.application.routes.default_url_options[:host]
    expect(rails_host).to eq described_class.default_host
  end

  it "has a default mailer from email address" do
    expect(described_class.mailer_from_address).to eq 'Klaxon <no-reply@newsklaxon.org>'
  end

  it "can have a custom mailer from email address" do
    ENV['MAILER_FROM_ADDRESS'] = "other-email"
    expect(described_class.mailer_from_address).to eq "other-email"
  end
end
