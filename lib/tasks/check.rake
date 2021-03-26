namespace :check do
  desc "Check all Pages for updates; send notifications for changes"
  task all: :environment do

    PollPage.perform_all

    # look for new changes
    Change.check
  end
end
