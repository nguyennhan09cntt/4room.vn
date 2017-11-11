class Default::GroupController < DefaultController	
	def index
		caterogy_identify = params[:identify] or params[:sub_indetify]

		caterogy = Category.where('identify = :identify', {:identify => caterogy_identify}).first
		if caterogy.present?
			@groups = Site.where('Category_id = :caterogy_id', {:caterogy_id => caterogy[:id]}).paginate(:page => params[:page], :per_page => 6).reorder("created_at DESC, id DESC")
		else
			redirect_to :controller => 'error', :action => '404'
		end
	end

	def show
		
	end
end
