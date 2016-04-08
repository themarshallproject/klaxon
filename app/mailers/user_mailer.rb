class UserMailer < ApplicationMailer
  def login_email(user: user, token: token)
    @user = user
    @url = token_session_url(token: token)
    mail(to: @user.email, subject: 'Log in to Klaxon')
  end
end
