class SiteController < ApplicationController

	def index
		@site = Site.paginate(:page => params[:page], :per_page => 10)
	end
end
