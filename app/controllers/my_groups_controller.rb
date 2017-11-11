class MyGroupsController < ApplicationController

  def index
    @site = Site.joins("LEFT JOIN `user_site` ON user_site.site_id = site.id")
    .where('user_id = :user_id', {user_id: @current_user[:id]}).paginate(:page => params[:page], :per_page => 10)
  end

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
    # msg = { :status => "ok", :message => "Success!", :html =>@groups }
    # render :json => msg
  end

  def create    
    group_params = params.require(:group).permit(:name, :facebook_id, :url, :cover)
    site = Site.new(group_params)
      if site.save
          UserSite.new(:site_id => site[:id], :user_id  => @current_user[:id]).save
         redirect_to :action => 'index'
      else
         render :action => 'facebook_group'
      end
  end
end
