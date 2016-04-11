require 'rails_helper'

RSpec.describe AppSetting, type: :model do

  it "returns false/empty if no app_setting" do
    AppSetting.where(key: 'default_host').delete_all
    expect(AppSetting.default_host_exists?).to eq false
    expect(AppSetting.default_host).to eq ''
  end

  it "gets the default host if it's set" do
    test_host = SecureRandom.hex
    setting = AppSetting.set_default_host(test_host)

    expect(AppSetting.default_host_exists?).to eq true
    expect(AppSetting.default_host).to eq test_host

    rails_host = Rails.application.routes.default_url_options[:host]
    expect(rails_host).to eq AppSetting.default_host
  end

end
