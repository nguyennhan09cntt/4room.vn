namespace :batch do
  desc "Run Import Post"
  task :import_post => :environment do
    msg = ''
    users = User.all
    begin
      users.each do |user|
        next if user[:access_token].blank?
        if valid_user_token user[:access_token]
          groups = UserSite.select('site.*').joins("JOIN site ON site.id = user_site.site_id").where('user_site.user_id = :user_id', user_id: user[:id])
          group_ids = groups.map(&:facebook_id)
          group_ids.each do |group_id|
            update_data user[:access_token], group_id
          end
        end
      end
    rescue => ex
      msg = ex.message +' APP TOKEN: '+ FACEBOOK_CONFIG['token']
    end
    p msg
    puts "End Task Import"
  end

  def valid_user_token(token)
    graph = Koala::Facebook::API.new FACEBOOK_CONFIG['token'], FACEBOOK_CONFIG['secret']
    data = graph.debug_token token
    data["data"]["is_valid"]
  end

  def update_data(access_token, group_id)
    site = Site.where('facebook_id = :group_id', {group_id: group_id}).first
    return if site.blank?

    facebook = Koala::Facebook::API.new(access_token)
    #   posts = facebook.get_object("#{group_id}/feed?limit=100")
    posts = facebook.get_connections(
      group_id,
      'feed', {
        limit: 100,
        fields: ['message', 'created_time', 'from', 'attachments']
      }
    )

    post_ids = posts.collect {|post| post['id']}
    post_exclude  = Post.where('facebook_id IN (:facebook_id)', {facebook_id: post_ids})
    post_exclude_ids = post_exclude.present? ? post_exclude.map(&:facebook_id) : []

    posts = posts.collect! do |fpost|
      post = {}

      post[:facebook_id] = fpost['id']
      post[:site_id] = site[:id]
      post[:status] = 2
      post[:created_at] = DateTime.parse(fpost['created_time']) + 7.hours


      if post_exclude_ids.include? post[:facebook_id]
        #p "Next: #{site_id}-#{member[:id]}"
        next
      end
      #post_record  = Post.where('facebook_id = :facebook_id', {facebook_id: post[:facebook_id]})
      #next if post_record.present?

      unless  fpost['message'].blank?
        messages = fpost['message'].split("\n\n")
        if messages.length == 1
          post[:content] = messages[0].scrub if messages[0].present?

          part_one_array = messages[0].split("\n")
          if part_one_array.length > 1
            messages[0] = part_one_array[0]
          end

          post[:name] = messages[0].split(' ').first(16).join(' ').each_char.select { |char| char.bytesize < 4 }.join if messages[0].present?
          if post[:name].present? and post[:name].length > 128
            post[:name] = post[:name].split(' ').first(8).join(' ')
          end
          post[:name] = post[:name] + '...' if post[:name].present?
        else
          part_one_array = messages[0].split("\n")
          post[:name] = part_one_array[0].each_char.select { |char| char.bytesize < 4 }.join if part_one_array[0].present?
          post[:name] = post[:name].split(' ').first(16).join(' ').each_char.select { |char| char.bytesize < 4 }.join if post[:name].present?
          if post[:name].present? and post[:name].length > 128
            post[:name] = post[:name].split(' ').first(8).join(' ')
          end
          post[:name] = post[:name] + '...' if post[:name].present?

          if part_one_array[1]
            address_price = part_one_array[1].split(" - ")
            post[:price] = address_price[0].gsub!(/[^0-9]/, '')
            post[:price] = 0 if post[:price].to_i < 500000
          end

          post[:content] = messages[1].scrub if messages[1].present?
        end
      end

      member = {}
      if fpost['from'].present?
        member[:facebook_id] = fpost['from']['id']
        member[:name] = fpost['from']['name']

        member_record = Member.where('facebook_id = :facebook_id', {facebook_id: member[:facebook_id] })
        if member_record.present?
          post[:member_id] = member_record[0][:id]
        else
          member_record = Member.new(member)
          if member_record.save
            post[:member_id] = member_record[:id]
          end
        end
      end

      if post.present? && post[:content].present?
        begin
          post = Post.new(post)
          post.save

          if fpost['attachments'].present?
          attachments = fpost['attachments']['data'][0]

          if attachments.present?
            if attachments['type'] == 'album'
              attachments['subattachments']['data'].each do |image_attach|
                if image_attach['type'] == 'photo'
                  image = {}
                  image[:name] = post[:name]
                  image[:post_id] = post[:id]
                  image[:url] = image_attach['media']['image']['src']
                  image_record = PostImage.new(image)
                  image_record.save
                  fpost[:image] = image
                end
              end
            end

            if attachments['type'] == 'photo'
              image = {}
              image[:name] = post[:name]
              image[:post_id] = post[:id]
              image[:url] = attachments['media']['image']['src']
              image_record = PostImage.new(image)
              image_record.save
              fpost[:image] = image
            end
          end
          end

          rescue Exception => e          
            p e.inspect   
            next
        end
      end

      post
    end
  end
end
