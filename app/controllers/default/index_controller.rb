class Default::IndexController < DefaultController

	def index
		@sites = Site.paginate(:page => params[:page], :per_page => 6)
		@filter = {}
	end
end
