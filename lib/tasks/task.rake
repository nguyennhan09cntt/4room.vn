namespace :batch do
  desc "Run Task"
  task :task => :environment do
    puts "Begin Task"
   
    puts "End Task"
  end  

end
