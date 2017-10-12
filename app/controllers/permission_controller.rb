class PermissionController < ApplicationController
  include PermissionHelper
  include UtilsHelper

  def show
    @user = User.find(params[:id])
    permission_data = UserPermission.search_by(@user.id)
    @permission_data = self.build_array_by_key(permission_data, 'privilege_id')
    @privilige_data = self.build_privilige(@user.fk_user_role)
    @role_data = UserRole.all
  end

  def update
    @user = User.find(params[:user_id])
    # user_attr = params.require(:user).permit(:fk_user_role)
    # @user.update_attributes(user_attr)
    privilege_ids = params[:privilege]
    unless @user.blank?
      UserPermission.delete_all(['fk_user = ?', @user.id])
      privilege_ids.each do |privilege_id, _|
        permission = UserPermission.new(:fk_user => @user.id, :fk_user_privilege => privilege_id)
        permission.save
      end
      redirect_to action: "show", id: @user.id
    end
  end
end
