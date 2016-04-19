namespace :users do
  desc "TODO"
  task create_admin: :environment do
    emails = ENV['ADMIN_EMAILS'].to_s.split(',')
    emails.each do |email|
      email.strip!
      User.where(email: email).first_or_create do |user|
        puts "ENV['ADMIN_EMAILS']: creating user with email='#{user.email}'"
      end
    end
  end

end
