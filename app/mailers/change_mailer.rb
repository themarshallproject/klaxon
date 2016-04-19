class ChangeMailer < ApplicationMailer

  def page(user: nil, change: nil)
    @change = change
    @page = @change.after.page
    @user = user

    mail(to: @user.email, subject: '[Klaxon] Change')
  end

end
