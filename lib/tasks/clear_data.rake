namespace :batch do
  desc "Run Task"
  task :clear_data => :environment do
    puts "Begin Task"
    sites = Site.all
    begin
      #site_uids = sample_range(1000000, sites.count)

      sites.each_with_index  do |site, site_index|
        begin

          posts = Post.where('site_id = :site_id and created_at < :approval_at', {:site_id => site[:id], :approval_at => DateTime.current - 1.month}).select(:id, :member_id)

          posts.each_with_index do |post, _index|
            p post[:id]

            begin
              PostImage.destroy_all(post_id: post[:id])
              post.destroy
            rescue => ex
              p ex
            end
          
          end
        rescue => e
          p e
        end
        p "End Site:#{site[:name]}"
      end
    rescue => ex
      msg = ex.message
    end
    p msg
    puts "End Task"
  end

end
