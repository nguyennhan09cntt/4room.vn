class PrivilegeController < ApplicationController
  def index
    unless params[:r].blank?
      @privilege = UserPrivilege.where('fk_user_resource = :user_resource', {:user_resource => params[:r]}).paginate(:page => params[:page], :per_page => 10)
      @resource = UserResource.find(params[:r])
      unless  @resource.nil?
        @resourceId = @resource.id
      else
        @resourceId = 0
      end
    else
      @privilege = UserPrivilege.all.order(:id).paginate(:page => 1, :per_page => 10)
    end
    @resourceData = UserResource.order(:name)
  end

  def new
    unless params[:m].blank?
      @resourceData = UserResource.where('fk_user_module = :fk_user_module', {:fk_user_module => params[:m]})
    else
      @resourceData = UserResource.all
    end

    @resourceId = params[:r]
  end

  def create
    @privilege = UserPrivilege.new(params.require(:privilege).permit(:name, :action, :priority, :display, :fk_user_resource))
    @resource = UserResource.find(params[:privilege][:fk_user_resource])
    @privilege.user_resource = @resource
    if @privilege.save
      redirect_to :action => 'index',:m => params[:m], :r => params[:privilege][:fk_user_resource]
    else
      render :action => 'new'
    end
  end

  def edit
    @privilege = UserPrivilege.find(params[:id])

    @resourceData = UserResource.where('fk_user_module = :fk_user_module', {:fk_user_module => @privilege.user_resource.fk_user_module})
  end

  def update
    @privilege = UserPrivilege.find (params[:id])
    @resource = UserResource.find(params[:privilege][:fk_user_resource])
    @privilege.user_resource = @resource
    @privilege.update_attributes(params.require(:privilege).permit(:name, :action, :priority, :display, :fk_user_resource))
    if @privilege.save
      redirect_to :action => 'index', :params =>{:m => params[:m], :r => params[:privilege][:fk_user_resource]}
    else
      render :action => 'new'
    end
  end

end
