class RoleController < ApplicationController
	include ModuleHelper
	def index
		@role = UserRole.paginate(:page => params[:page], :per_page => 10)
	end

	 def show
	    redirect_to :action => 'index'
	 end

	def new
		@privilege_data = self.build_all_privilige			
	end

	def create
	@role = UserRole.new(params.require(:role).permit(:name))
	 if @role.save
	     redirect_to :action => 'index'
	  else
	     render :action => 'new'
	  end
	end

	def edit
	 @role = UserRole.find(params[:id])
	end

	def update

	@role = UserRole.update_attributes(params.require(:role).permit(:name, :id))
	 if @role.save
	     redirect_to :action => 'index'
	  else
	     render :action => 'edit'
	  end

	end

	def destroy
	end
end
