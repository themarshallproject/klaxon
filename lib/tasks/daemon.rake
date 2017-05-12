task daemon: :environment do
  while 1
    puts "checking"
    begin
      PollPage.perform_all
    rescue
      puts "Error in PollPage.perform_all!"
    end

    # look for new changes
    Change.check
    puts "sleeping 10 min at #{Time.now}"
    sleep 60 * 10
  end
end
