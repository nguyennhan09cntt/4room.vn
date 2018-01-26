namespace :batch do
  desc "Run Task"
  task :backup_data => :environment do
    puts "Begin Task"
   	p Post.random_uid
    puts "End Task"
  end  

end
