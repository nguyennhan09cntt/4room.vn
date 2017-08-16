class PermissionController < ApplicationController

  def show
    @permission_data = UserPermission.where(
      'fk_user= :fk_user',
      {:fk_user => params[:id]},
      :joins => [:user_privilege, :user_resource, :user_module]
    )
    @user = User.find(params[:id])
    
  end

  def update
  end
end
