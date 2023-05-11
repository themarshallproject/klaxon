scheduler = Rufus::Scheduler.new

scheduler.every '10m' do
  PollPage.perform_all
  Change.check
end
