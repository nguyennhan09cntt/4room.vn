class Default::PostController < DefaultController	
	def index
		group_id = '545206412228291'
    if params[:group_id].present?
    	group_id = params[:group_id]
    end
    @site = Site.where('facebook_id = :group_id', {group_id: group_id}).first
    @posts = Post.where('site_id = :site_id', {site_id: @site[:id]}).paginate(:page => params[:page], :per_page => 6).reorder("created_at DESC, id DESC")
	end

	def show
		
	end
end
