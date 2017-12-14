class MyGroupsController < ApplicationController

  def index
    @site = Site.joins("LEFT JOIN `user_site` ON user_site.site_id = site.id")
    .where('user_id = :user_id', {user_id: @current_user[:id]}).paginate(:page => params[:page], :per_page => 10)
  end

  # admin group
  def facebook_group
    access_token = current_user[:access_token]
    facebook = Koala::Facebook::API.new(access_token)
    Koala.config.api_version = "v2.10"
    @groups = facebook.get_connections('me', 'groups')
    group_list = []
    @groups.collect do |group|
      group_info = facebook.get_object(group['id']+'?fields=cover')
      group['cover'] = group_info['cover']
    end

    @site = Site.joins("LEFT JOIN `user_site` ON user_site.site_id = site.id")
    .where('user_id = :user_id', {user_id: @current_user[:id]})
    @site = @site.map(&:facebook_id) if @site.present?
    
  end

  def facebook_public
    @groups = {}
    if params[:keyword].present?
      access_token = current_user[:access_token]
      facebook = Koala::Facebook::API.new(access_token)
      Koala.config.api_version = "v2.10"
      @groups = facebook.search(params[:keyword], type: :group)
      @groups.collect do |group|
        group_info = facebook.get_object(group['id']+'?fields=cover')
        member_summary = facebook.get_connections(group['id'], 'members', {summary: true, limit: 1})
        #logger.debug member_summary.summary
        group['cover'] = group_info['cover']
        group['member_count'] = member_summary.summary['total_count'].blank? ? 0 : member_summary.summary['total_count'] 
      end

      @site = Site.joins("LEFT JOIN `user_site` ON user_site.site_id = site.id")
      .where('user_id = :user_id', {user_id: @current_user[:id]})
      @site = @site.map(&:facebook_id) if @site.present?     
    end
  end

  def create
    group_params = params.require(:group).permit(:name, :facebook_id, :url, :cover, :member_count)
    site = Site.where('facebook_id = :facebook_id', {facebook_id: group_params[:facebook_id]}).first
    if site.present?
      UserSite.new(:site_id => site[:id], :user_id  => @current_user[:id]).save
      redirect_to :action => 'index'
    else
      site = Site.new(group_params)
      if site.save
        UserSite.new(:site_id => site[:id], :user_id  => @current_user[:id]).save
        redirect_to :action => 'index'
      else
        render :action => 'facebook_group'
      end
    end

  end
end
