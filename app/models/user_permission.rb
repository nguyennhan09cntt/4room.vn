class UserPermission < ApplicationRecord
  self.table_name = "user_permission"
  belongs_to :user_privilege, foreign_key: 'fk_user_privilege'

  def self.search_by(user_id)
    query = "SELECT
			    user_permission.*,
			    user_privilege.id AS privilege_id,
			    user_privilege.name AS privilege_name,
			    user_privilege.action as privilege_action,
			    user_privilege.active AS privilege_active,
			    user_privilege.display as privilege_display,
			    user_resource.id AS user_resource_id,
			    user_resource.name as resource_name,
			    user_resource.active as resource_active,
			    user_resource.display as resource_display,
			    user_resource.controller as resource_controller,
			    user_module.id as module_id,
			    user_module.name as module_name
			FROM
			    user_permission
			        JOIN
			    user_privilege ON user_privilege.id = user_permission.fk_user_privilege
			        JOIN
			    user_resource ON user_resource.id = user_privilege.fk_user_resource
			        JOIN
			    user_module ON user_module.id = user_resource.fk_user_module

			WHERE
			     user_permission.fk_user = #{user_id}"
    return self.connection.exec_query(query).to_hash
  end
end
