host = AppSetting.default_host
if host.nil?
  Rails.logger.error "Could not determine default_host!"
else
  Rails.application.routes.default_url_options[:host] = host
end
