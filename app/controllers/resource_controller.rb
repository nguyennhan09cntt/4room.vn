class ResourceController < ApplicationController
  def index

    unless params[:m].nil? or params[:m] == 0  or params[:m] == ''
      @resource = UserResource.where('fk_user_module = :user_module', {:user_module => params[:m]}).paginate(:page => params[:page], :per_page => 10)
      @module = UserModule.find(params[:m]);
      unless  @module.nil?
        @moduleId = @module.id
      else
        @moduleId = 0
      end

    else
      @resource = UserResource.paginate(:page => params[:page], :per_page => 10)
      @moduleId = 0
    end
    @moduleData = UserModule.order(:name)

  end

  def show
    redirect_to :action => 'index'
  end

  def new
    unless params[:m].nil? or params[:m] == 0  or params[:m] == ''
      @module = UserModule.find(params[:m])
      unless  @module.nil?
        @moduleId = @module.id
      else
        @moduleId = 0
      end
    else
      @moduleId = 0
    end
    @moduleData = UserModule.order(:name)
  end

  def create
    @module = UserModule.find(params[:resource][:fk_user_module])
    params_created = params.require(:resource).permit(:name, :controller, :active, :display)
    @resource = UserResource.new(params_created)
    @resource.user_module = @module
    if @resource.save
      redirect_to :action => 'index'
    else
      @moduleData = UserModule.order(:name)
      render :action => 'new'
    end
  end

  def edit
    @resource = UserResource.find(params[:id])
    @moduleData = UserModule.order(:name)
  end

  def update
    resource_attr = params.require(:resource).permit(:name, :controller, :active, :display)
    @resource  = UserResource.find(params[:id])
    @resource.update_attributes(resource_attr)
    if @resource.save
      #Rails.logger.info(@user.errors.inspect)
      redirect_to :action => 'index'
    else
      #Rails.logger.info(@user.errors.inspect)
      redirect_to :action => 'edit'
    end
  end

  def destroy

  end

end
