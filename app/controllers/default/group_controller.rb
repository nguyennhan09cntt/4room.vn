class Default::GroupController < DefaultController	
	def index
		caterogy_identify = params[:sub_indetify]
		caterogy_identify = params[:identify] if caterogy_identify.blank?
		
		caterogy = Category.where('identify = :identify', {:identify => caterogy_identify}).first
		if caterogy.present?
			@groups = Site.where('Category_id = :caterogy_id', {:caterogy_id => caterogy[:id]}).paginate(:page => params[:page], :per_page => 6).reorder("created_at DESC, id DESC")
		else
			redirect_to :controller => 'error', :action => '404'
		end
	end

	def show
		group_id = '1599535'
    if params[:group_id].present?
    	group_id = params[:group_id]
    end
    @site = Site.where('uid = :group_id', {group_id: group_id}).first
	end
end
