class SiteController < ApplicationController

	def index
		@sites = Site.paginate(:page => params[:page], :per_page => 10)
	end
end
