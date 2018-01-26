namespace :batch do
  desc "Run Task"
  # batch:repost[545206412228291, 202567426949171]
  task :repost, [:page_from, :page_to] => :environment do  |t, args|
    # 545206412228291 
    # 202567426949171 group_facebook_id
    puts "Begin Task"

    access_token = 'EAAL3tYEPxDcBAD4k60d5PA9xwCblTZBPQRf0BrDKfpfZBsEDA6OE68nBhXnk3RdrC4SIRRRv7cw108ZCnYVBJ4mk8NIN6Jcmv3cVArFzFG8ZCsteo8QqvZBAHD0HoGero3CSnYfNJWDWAfpGI3f7rZCzdjQHYjMsoZD'
    if valid_user_token(access_token)
      p "valid_user_token"
      koala_page = Koala::Facebook::API.new(access_token)
      
      #   posts = facebook.get_object("#{group_id}/feed?limit=100")
      p args[:page_from]
      posts = koala_page.get_connections(
        args[:page_from],
        'feed', {
          limit: 100,
          fields: ['message', 'created_time', 'from', 'attachments']
        }
      )
      posts = posts.sample(2)
      posts.each do |post|
        begin
          picture_url = '' #'https://cdn57.androidauthority.net/wp-content/uploads/2015/11/00-best-backgrounds-and-wallpaper-apps-for-android.jpg' #post[]
          link_url = ''
          next if  post['message'].blank?
          message =  post['message'] +" \n "+ "Lien he: #{post['from']['name']} \n https://www.facebook.com/#{post['id']}" 
          p post['id']
          # if uid_array.length == 2
          #   link_url = "http://ln3.in/#{uid_array[0]}/post/#{uid_array[1]}"

          # end
          # link_url = "http://facebook.com/#{post['id']}"
          # p post
          times = [100.0, 200.0, 300.0, 150.0, 80.0, 110.0]
          time = times.sample
          koala_page.put_connections(args[:page_to], 'feed', :message => message, :picture => picture_url, :link => link_url)                    
          
          koala_page.put_connections('375742012634562', 'feed', :message => message, :picture => picture_url, :link => link_url)
                    
          koala_page.put_connections('1425895344371263', 'feed', :message => message, :picture => picture_url, :link => link_url)
          # koala_page.put_connections('538237506331203', 'feed', :message => message, :picture => picture_url, :link => link_url)          
          
          
          sleep(time)
        rescue => ex
          msg = ex.message +' APP TOKEN: '+ FACEBOOK_CONFIG['token']
          p msg
          sleep(100.0)
        ensure
          next
        end
        
      end
    end


    puts "End Task"
  end

  def valid_user_token(token)
    # graph = Koala::Facebook::API.new FACEBOOK_CONFIG['token'], FACEBOOK_CONFIG['secret']
    # data = graph.debug_token token
    # data["data"]["is_valid"]
    true
  end

end
