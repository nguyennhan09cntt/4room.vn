class ProfileController < ApplicationController
	def index
		
	end

	def update
	    user_params_update = params.require(:user).permit(:name, :birthday, :job, :phone)
	    @user  = User.find(session[:user_id])

	    @user.update_attributes(user_params_update)

	    if @user.save        
	        redirect_to :action => 'index'
	    else         
	        redirect_to :action => 'index'
	    end

   end
end
