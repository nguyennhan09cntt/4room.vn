namespace :batch do
  desc "Run Task Member"
  task :import_member => :environment do
    puts "Begin Task import"
    msg = ''
    users = User.all
    #Site.update_all import_member: 0
    begin
      users.each do |user|
        next if user[:access_token].blank?
        if valid_user_token user[:access_token]
          groups = UserSite.select('site.*').joins("JOIN site ON site.id = user_site.site_id").where('user_site.user_id = :user_id and site.import_member = 0', user_id: user[:id])
          group_ids = groups.map(&:facebook_id)
          groups.each do |group|
            begin
              update_data_member user[:access_token], group[:facebook_id], group[:id]
            rescue Exception => e            
             
              p e.inspect
            end
          end
        end
      end
      # Site.update_all import_member: 0
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

  def update_data_member(access_token, facebook_id, site_id)
    p "Facebook-Site: #{facebook_id} - #{site_id}"

    date_time = DateTime.now.in_time_zone('Asia/Ho_Chi_Minh')
    cnt_page = 0
    facebook = Koala::Facebook::API.new(access_token)
    #members = facebook.get_connections(facebook_id, 'members', {limit: 100})
    members_api = facebook.get_connections(
      facebook_id,
      'members',
      {
        limit: 500,
        fields: ['cover', 'name', 'administrator', 'id']
      }
    )
    return if members_api.blank?
    while members_api.present?
      cnt_page = cnt_page + 1
      members = {}
      member_face_ids = []
      members = members_api.collect do |fb_member|
        member = {}
        member[:facebook_id] = fb_member['id']
        member[:name] = fb_member['name'].strip
        member[:cover] = fb_member['cover']['source'] if fb_member['cover'].present? && fb_member['cover']['source'].present?
        member[:administrator] = fb_member['administrator']
        member[:created_at] = date_time
        member_face_ids << fb_member['id']
        member
      end

      member_records = Member.select('facebook_id', 'id')
      .where('facebook_id IN (:member_face_ids)', {member_face_ids: member_face_ids})
      member_records_id = member_records.present? ? member_records.map(&:facebook_id) : []

      members.each do |member|
        next if member_records_id.include? member[:facebook_id]
        begin
           member = Member.new(member)
          if member.save
            #p "Insert member: #{site_id}-#{member[:id]}"
            SiteMember.create({site_id: site_id, member_id: member[:id], created_at: date_time})
          end
        rescue Exception => e          
            p e.inspect          
        end
       
      end
      if member_records.present?
        exclude_member = SiteMember.where('member_id IN (:member_id) and site_id = :site_id', { member_id: member_records.map(&:id), site_id: site_id })
        exclude_member_ids = exclude_member.present? ? exclude_member.map(&:member_id) : []
        #puts "exclude_member_ids: #{exclude_member_ids}"
        member_records.each do |member|
          if exclude_member_ids.include? member[:id]
            #p "Next: #{site_id}-#{member[:id]}"
            next
          end

          begin
            #p "Insert SiteMember: #{site_id}-#{member[:id]}"
            SiteMember.create({site_id: site_id, member_id: member[:id], created_at: date_time})
          rescue Exception => e
            p e.inspect
          end
        end
      end
      #p "page: #{cnt_page}"
      begin
        members_api = members_api.next_page

      rescue Exception => e
        members_api = {}
        p "page: #{cnt_page}"
        p e.inspect
      end
    end
    Site.update(site_id, import_member: 1)
    p "page: #{cnt_page}"
  end
end
