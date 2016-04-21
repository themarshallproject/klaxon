class ApplicationMailer < ActionMailer::Base
  # TODO consider http://stackoverflow.com/a/8106387
  default from: "Klaxon <#{ENV["EMAIL_FROM_ADDRESS"]}>"
  layout 'mailer'
end
