begin
  if Rails.application.routes.default_url_options[:host].blank? and AppSetting.default_host_exists?
    host = AppSetting.default_host
    Rails.logger.info "[SUCCESS] Setting default_url_options[:host] = '#{host}'"
    Rails.application.routes.default_url_options[:host] = host
  end
rescue ActiveRecord::NoDatabaseError
  Rails.logger.error "[ERROR] Failed to set default_host because: ActiveRecord::NoDatabaseError. If this is the first deploy, this is expected and will be fixed after the database is created."
rescue ActiveRecord::StatementInvalid
  Rails.logger.error "[ERROR] Failed to set default_host because: ActiveRecord::StatementInvalid. If this is the first deploy, this is expected and will be fixed after the database is migrated."
end
