class ApplicationMailer < ActionMailer::Base
  # TODO consider http://stackoverflow.com/a/8106387
  default from: 'Klaxon <no-reply@newsklaxon.org>'
  layout 'mailer'
end
