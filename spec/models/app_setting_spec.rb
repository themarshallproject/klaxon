require 'rails_helper'

RSpec.describe AppSetting, type: :model do

  it "returns false if no app_setting" do
    AppSetting.where(key: 'default_host').delete_all
    expect(AppSetting.default_host_exists?).to eq false
    expect(AppSetting.default_host).to eq ''
  end

  it "gets the default host if it's set" do
    setting = AppSetting.where(key: 'default_host').first_or_create
    setting.value = SecureRandom.hex
    setting.save

    expect(AppSetting.default_host_exists?).to eq true
    expect(AppSetting.default_host).to eq setting.value
  end

end
