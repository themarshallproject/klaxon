begin
  if Rails.application.routes.default_url_options[:host].blank? and AppSetting.default_host_exists?
    host = AppSetting.default_host
    Rails.logger.info "setting default_host to #{host}"
    Rails.application.routes.default_url_options[:host] = host
  end
rescue
  puts "failed to set default_host, reason: #{$!}"
end
