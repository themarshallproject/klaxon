class ApplicationMailer < ActionMailer::Base
  # TODO consider http://stackoverflow.com/a/8106387
  default from: AppSetting.mailer_from_address
  layout 'mailer'
end
