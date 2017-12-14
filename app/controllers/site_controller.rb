class SiteController < ApplicationController

	def index
		@sites = Site.paginate(:page => params[:page], :per_page => 10)
	end

	def edit
      @site = Site.find(params[:id])
      categorys = Category.all            
      @category_data = {}
      categorys.each do |category|
      	if category.parent_id.blank? and !@category_data.key?(category.id) 
      		@category_data[category.id] = {label: category.name, sub_cate: {}}
      		next
      	end
      	logger.debug category.inspect
      	@category_data[category.parent_id][:sub_cate][category.id] = category.name
      end
   end

   def update
      params_update = params.require(:site).permit(:description, :category_id)
      @site  = Site.find(params[:id])

      @site.update_attributes(params_update)

      if @site.save         
         redirect_to :action => 'index'
      else         
         redirect_to :action => 'edit'
      end


   end
end
