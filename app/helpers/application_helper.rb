module ApplicationHelper
  def menu
    permissionData = UserPermission.where(
      'fk_user= :fk_user',
      {:fk_user => @current_user.id},
      :joins => [:user_privilege, :user_resource, :user_module]
    )
    @menuData = Hash.new
    unless  permissionData.nil?
      permissionData.each do |data|
        if data.user_privilege.user_resource.user_module.fk_user_component == ApplicationConstant::COMPONENT_CMS
          if data.user_privilege.user_resource.display == ApplicationConstant::DISPLAY
            moduleName = data.user_privilege.user_resource.user_module.name
            unless @menuData[moduleName]
              @menuData[moduleName] = Hash.new
            end

            resourceName = data.user_privilege.user_resource.name;
            if @menuData[moduleName][resourceName] == nil
              @menuData[moduleName][resourceName] = Hash.new
            end
            controller = data.user_privilege.user_resource.controller
            action = data.user_privilege.action
            link = "/#{controller}"
            @menuData[moduleName][resourceName][controller] = Hash[
              CMSConstant::PREFIX_MENU_NAME => data.user_privilege.name,
              CMSConstant::PREFIX_MENU_URL => link
            ]
          end
        end
      end
    end    
    render :partial => 'layouts/menu'
  end
end
