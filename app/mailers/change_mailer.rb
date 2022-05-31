class ChangeMailer < ApplicationMailer
  def page(user: nil, change: nil)
    @change = change
    @page = @change.after.page
    @user = user
    if ENV['KLAXON_INSTANCE_NAME'].present?
           @instanceid = "Klaxon @ #{ENV['KLAXON_INSTANCE_NAME']}"
        else
           @instanceid = "Klaxon"
     end
    mail(to: @user.email, subject: "#{@instanceid}: #{@page.name} changed"
  end
end
