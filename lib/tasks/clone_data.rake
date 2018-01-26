namespace :batch do
  desc "Run Task"
  task :clone_data, [:page_from, :page_to] => :environment do  |t, args|
    # 1512571043 site_uid
    # 202567426949171 group_facebook_id
    puts "Begin Task"
    
    access_token = 'EAAILwDlIRAwBACsz7b5qiOB5AftdxguVkZAJ83Uond7ZBJrvflDdTQU0RSRarxOlieOZAHbGx99XZCTIwL6CSG5QtlnBpTFVvUrA3pSCtD6TPf60K8b0jdEgMh5HsnxVSzlotuZAgyRX90730xj31Y4Cw3PMOFSKah70vg7ihAQSmZCpNCp4MZA6HZA30Fjmgmag7ZBM50cmOSgZDZD'
    if valid_user_token(access_token)
      p "valid_user_token"
      koala_page = Koala::Facebook::API.new(access_token)
      posts = Post.where('uid LIKE :page_id and created_at >= DATE_SUB(NOW(), INTERVAL 2 HOUR)', {:page_id => "#{args[:page_from]}_%"}).reorder("created_at DESC, id DESC").limit(50)
      posts.each do |post|
        begin
          p "post:", post[:id]
          picture_url = 'http://ln3.in/assets/img/portfolio/1200x900/1.jpg' #post[]
          link_url = ''
          uid_array = post[:uid].split("_")
          if uid_array.length == 2
            link_url = "http://ln3.in/#{uid_array[0]}/post/#{uid_array[1]}"

          end
          p link_url
          koala_page.put_connections(args[:page_to], 'feed', :message => post[:content], :picture => picture_url, :link => link_url)
        rescue => ex
          msg = ex.message +' APP TOKEN: '+ FACEBOOK_CONFIG['token']

        end
        p msg
      end
    end


    puts "End Task"
  end

  def valid_user_token(token)
    graph = Koala::Facebook::API.new FACEBOOK_CONFIG['token'], FACEBOOK_CONFIG['secret']
    data = graph.debug_token token
    data["data"]["is_valid"]
  end

end
