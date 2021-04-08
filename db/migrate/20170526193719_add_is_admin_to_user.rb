class AddIsAdminToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :is_admin, :boolean

    # Set new `is_admin` field for users listed in the `ADMIN_EMAILS`
    # environment variable, if it exists
    emails = ENV['ADMIN_EMAILS'].to_s.split(',')
    emails.each do |email|
      email.strip!
      user = User.where(email: email).first_or_create do |user|
        puts "ENV['ADMIN_EMAILS']: creating user with email='#{user.email}'"
      end
      user.is_admin = true
      user.save
    end

    # The below only should apply to people hosting Klaxon themselves rather
    # than on Heroku, and only in certain situations.
    if emails.empty?
      puts <<~EOF
        Your ADMIN_EMAILS environment variable was empty.

        If you want to be able to delete users from within the Klaxon
        Web interface, set up at least one admin user.

        The easiest way to do this is to run the "users:create_admin"
        Rake task with the ADMIN_EMAILS environment variable set.
      EOF
    end
  end
end
