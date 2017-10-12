class LoginController < ApplicationController
	skip_before_filter :authenticate_user
	before_action :save_login_state, :only => [:login, :login_attempt]

	layout false

	def index

	end

	def login
		authorized_user = User.authenticate(params[:username],params[:password])

	    if authorized_user
	    	authorized_user.last_login = DateTime.now.to_date
	    	authorized_user.save
	    	session[:user_id] = authorized_user.id
	      	flash[:notice] = "Wow Welcome again, you logged in as #{authorized_user.user_name}"
	      	redirect_to(:controller => 'index')
	    else
	      	flash[:notice] = "Invalid Username or Password"
	      	flash[:color]= "invalid"
	      	redirect_to(:action => 'login')
		end
	end

	def logout
		session[:user_id] = nil
		redirect_to :action => 'login'
	end

	def facebook
		auth = request.env['omniauth.auth']['credentials']
		access_token = auth['token']
    face_user = User.koala(auth)
    redirect_to(:action => 'login') if face_user.blank?
		user = User.where("facebook_id = :facebook_id", {:facebook_id => face_user['id']})
		# msg = { :status => "ok", :message => "Success!", :html => user}
    # render :json => msg
    user_params = {}
    unless user.blank?
    	user = user.first
	    session[:user_id] = user.id
	    user_params[:access_token] = access_token
	    user.update_attributes(user_params)
	    user.save(validate: false)
    else
    	user_params[:name] = face_user['name']
    	user_params[:facebook_id] = face_user['id']
    	user_params[:birthday] = face_user['birthday']
    	user_params[:access_token] = access_token
    	#user_params[:email] = face_user[:email]
    	user_params[:user_name] = face_user['email'] || face_user['id']
    	user = User.new(user_params)
    	# msg = { :status => "ok", :message => "Success!", :html => user_params}
	    # render :json => msg
    	if user.save(validate: false)
    		session[:user_id] = user.id
    	else
    		redirect_to(:action => 'login') and return
    	end
    end

    redirect_to(:controller => 'index')
  end
end
