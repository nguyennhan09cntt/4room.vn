class UserController < ApplicationController
   def index
      if @current_user[:level] == 1
         # @users = User.where(
         #       'id != :current_user_id',
         #       {level: @current_user[:level], current_user_id: @current_user[:id]}
         #    ).paginate(:page => params[:page], :per_page => 10)
         @users = User.paginate(:page => params[:page], :per_page => 10)
      else
         @users = User.where(
               'level > :level and id != :current_user_id and manager_id = :manager_id',
               {level: @current_user[:level], current_user_id: @current_user[:id], manager_id: @current_user[:id]}
            ).paginate(:page => params[:page], :per_page => 10)
      end

   end

   def show
       @user = User.find(params[:id])
   end

   def new
      @role_data = UserRole.all
   end

   def create
      level = @current_user[:level] +1
      user_params = self.user_param
      user_params['level'] = level
      user_params['manager_id'] = @current_user[:id]
      @user = User.new(user_params)
      if @user.save
         redirect_to :action => 'index'
      else
         render :action => 'new'
      end
   end

   def edit
      @user = User.find(params[:id])
      @role_data = UserRole.all
   end

   def update
      user_params_update = params.require(:user).permit(:name, :birthday, :job, :phone, :fk_user_role)
      @user  = User.find(params[:id])

      @user.update_attributes(user_params_update)

      if @user.save
         #Rails.logger.info(@user.errors.inspect)
         redirect_to :action => 'index'
      else
         #Rails.logger.info(@user.errors.inspect)
         redirect_to :action => 'edit'
      end


   end

   def destroy
     if User.find(params[:id]).destroy
         redirect_to :action => 'index'
     else
         redirect_to :controler => 'error', :action => '500'
     end
   end

   def user_param
      @user_params = params.require(:user).permit(:user_name, :name, :birthday, :password, :job, :phone, :fk_user_role)
   end
end
