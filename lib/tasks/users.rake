namespace :users do
  desc "TODO"
  task create_admin: :environment do
    emails = ENV['ADMIN_EMAILS'].to_s.split(',')
    emails.each do |email|
      email.strip!
      user = User.where(email: email).first_or_create do |user|
        puts "ENV['ADMIN_EMAILS']: creating user with email='#{user.email}'"
      end
      user.is_admin = true
      user.save
    end
  end

end
