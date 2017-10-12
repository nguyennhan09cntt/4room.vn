class RoleController < ApplicationController
  include ModuleHelper

  def index
    @role = UserRole.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    redirect_to :action => 'index'
  end

  def new
    @module_data = self.build_all_privilige
  end

  def create
    @role = UserRole.new(params.require(:role).permit(:name))
    if @role.save
      privilege_data = params.require(:role).permit(:privilege)
      privilege_data.each do |value|
        UserAcl.new( { 'fk_user_role' => @role.id, 'fk_user_privilege' => value} )
      end

      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @role = UserRole.find(params[:id])
    @role_data = self.build_all_privilige
  end

  def update
    @role = UserRole.find(params[:id])
    @role.update_attributes(params.require(:role).permit(:name))
    if @role.save
      UserAcl.delete_all(['fk_user_role = ?', @role.id])
      privilege_data = params['privilege']     
      privilege_data.each do |value|
        privilege = UserAcl.new(:fk_user_role => @role.id, :fk_user_privilege => value)
        privilege.save
      end
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end

  end

  def destroy
  end
end
