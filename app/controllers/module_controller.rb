class ModuleController < ApplicationController
  def index
    unless (params[:c].nil? || params[:c] == 0 )
      @module = UserModule.where('fk_user_component = :user_component', {:user_component => params[:c]}).paginate(:page => params[:page], :per_page => 10)
    else
      @module = UserModule.paginate(:page => params[:page], :per_page => 10)
    end
  end

  def show
    redirect_to :action => 'index'
  end

  def new
    @component = UserComponent.order(:name)
  end

  def create
    @module = UserModule.new(params.require(:module).permit(:name, :priority, :fk_user_component))
     if @module.save
         redirect_to :action => 'index'
      else
         render :action => 'new'
      end
  end

  def edit
     @module = UserModule.find(params[:id])
  end

  def update

    @module = UserModule.update_attributes(params.require(:module).permit(:name, :priority, :fk_user_component, :id))
     if @module.save
         redirect_to :action => 'index'
      else
         render :action => 'edit'
      end

  end

  def destroy

  end
end
