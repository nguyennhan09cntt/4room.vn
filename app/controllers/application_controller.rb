class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user
  config.time_zone = 'HaNoi'


  Default = 'default'
  
  include SessionHelper

  protected 
	def authenticate_user
		
	  if session[:user_id]
	  
	    # set current user object to @current_user object variable
	    @current_user = User.find(session[:user_id])
	    return true	
	  else
	    redirect_to(:controller => 'login', :action => 'index')
	    return false
	  end
	end
	def save_login_state
	  if session[:user_id]
	    redirect_to(:controller => 'index', :action => 'index')
	    return false
	  else
	    return true
	  end
	end
  
end
