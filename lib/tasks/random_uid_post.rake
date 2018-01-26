namespace :batch do
  desc "Run Task Random UID POST"
  task :random_uid_post => :environment do
    puts "Begin Task Random UID POST"
    msg = ''
    #Site.update_all uid: nil
    #Post.where('uid is not null').update_all uid: nil
    #PostImage.where('post_uid is not  null').update_all post_uid: nil

    # sites = Site.where('uid is null')
    sites = Site.where('id = 14')
    begin
      site_uids = sample_range(1000000, sites.count)

      sites.each_with_index  do |site, site_index|
        begin
          
          if site.update(uid: site_uids[site_index].to_s)
          #if true
            p site[:uid] 
            posts = Post.where('site_id = :site_id and uid is null', {:site_id => site[:id]}).select(:id, :member_id)
            number = posts.count(:id)
            uids = sample_range(1000000, number)
            posts.each_with_index do |post, _index|
              p post[:id]	
              uid = site[:uid] + "_" + uids[_index].to_s
              if post.update(uid: uid)
                # sleep(1.0/20.0)
                begin
                  PostImage.where(post_id: post[:id]).update_all(post_uid: uid)
                rescue => ex
                  p ex
                end
              end
              # sleep(1.0/20.0)

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
    puts "End Task Random UID POST"
  end

  def sample_range(_begin = 1000000, number)
    step = number > 999999 ? number : 999999
    _end =    _begin + step
    range = [(_begin .. _end)].map{ |i| i.to_a }.flatten
    range.sample(number)
  end

end
