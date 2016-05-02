class ApplicationMailer < ActionMailer::Base
  # TODO consider http://stackoverflow.com/a/8106387
<<<<<<< HEAD
  default from: "Klaxon <#{ENV["EMAIL_FROM_ADDRESS"]}>"
=======
  default from: AppSetting.mailer_from_address
>>>>>>> 8e8b608ee081e53d392603b955bd51293c9b5742
  layout 'mailer'
end
