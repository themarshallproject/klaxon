task :daemon do
  while 1
    puts "checking"
    Rake::Task["check:all"].reenable
    Rake::Task["check:all"].invoke
    puts "sleeping"
    sleep 60 * 10
  end
end
