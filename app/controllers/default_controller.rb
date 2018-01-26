class DefaultController < ActionController::Base
  before_action :authenticate_user

  protected
  def authenticate_user

    if session[:user_id]

      # set current user object to @current_user object variable
      @current_user = User.find(session[:user_id])
      return true
    else
      redirect_to('/login')
      return false
    end
  end
end
