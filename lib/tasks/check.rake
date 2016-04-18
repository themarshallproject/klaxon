namespace :check do
  desc "Check all Pages for updates; send notifications for changes"
  task all: :environment do

    begin
      PollPage.perform_all
    rescue
      puts "Error in PollPage.perform_all!"
    end

    # look for new changes
    Change.check

  end

end
