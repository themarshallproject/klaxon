# Preview all emails at http://localhost:3000/rails/mailers/change_mailer
class ChangeMailerPreview < ActionMailer::Preview
    def change_email
       ChangeMailer.with(user: User.first, change: Change.first).page
      end
end