class MemberController < ApplicationController

  def index
    group_id = '545206412228291'
    if params[:group_id].present?
      group_id = params[:group_id]
    end
    @site = Site.where('facebook_id = :group_id', {group_id: group_id}).first

    @members = Member.select('member.*').joins("LEFT JOIN `site_member` ON site_member.member_id = member.id").where('site_id = :site_id', {site_id: @site[:id]}).paginate(:page => params[:page], :per_page => 25).reorder("created_at DESC, id DESC")
  end

  def export_data
  end

  def update_data
    members = {}
    member_face_ids = []
    date_time = DateTime.now.in_time_zone('Asia/Ho_Chi_Minh')
    @user = current_user
    access_token = @user[:access_token]
    group_id = '545206412228291'
    if params[:group_id].present?
      group_id = params[:group_id]
    end

    site = Site.where('facebook_id = :group_id', {group_id: group_id}).first
    return if site.blank?

    facebook = Koala::Facebook::API.new(access_token)
    #members = facebook.get_connections(group['id'], 'members', {limit: 100})
    
    begin
      members_api = facebook.get_connections(
        group_id,
        'members',
        {
          limit: 1000,
          fields: ['cover', 'name', 'administrator', 'id']
        }
      )
      members = members_api.collect do |fb_member|
      	member = {}
      	member[:facebook_id] = fb_member['id']
      	member[:name] = fb_member['name']
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
        member = ember.new(member)
        if member.save
          SiteMember.create({site_id: site[:id], member_id: member[:id], created_at: date_time})
        end                 
      end

      member_records.each do |member|
        begin
          SiteMember.create({site_id: site[:id], member_id: member[:id], created_at: date_time})  
        rescue Exception => e
          logger.debug e.inspect
        end        
      end


      
      # (1..100).each do	
      # members_api = members_api.next_page
      # break if members_api.blank?
      # end
    end
    # end while members_api.present?

    msg = { :status => "ok", :message => "Success!", :html => (member_face_ids - member_records_id) }
    render :json => msg
  end
end
