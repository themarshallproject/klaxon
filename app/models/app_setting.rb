class AppSetting < ApplicationRecord

  def self.default_host_key
    'default_host'
  end

  def self.default_host_exists?
    self.where(key: self.default_host_key).exists?
  end

  def self.set_default_host(host)
    setting = self.where(key: self.default_host_key).first_or_initialize
    puts "Setting default_host to #{host}"
    setting.value = host
    setting.save

    Rails.application.routes.default_url_options[:host] = host
  end

  def self.default_host
    self.find_by(key: self.default_host_key)&.value.to_s
  end

  def self.mailer_from_address
    if ENV['MAILER_FROM_ADDRESS'].present?
      ENV['MAILER_FROM_ADDRESS']
    else
      'Klaxon <no-reply@newsklaxon.org>'
    end
  end

end
